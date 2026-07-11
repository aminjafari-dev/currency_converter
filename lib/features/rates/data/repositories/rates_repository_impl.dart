import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/features/rates/data/datasources/local/rates_local_data_source.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/frankfurter_remote_data_source.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';

/// Concrete [RatesRepository] — single source of truth for rates + selection.
///
/// Online: fetch remote → cache → return domain entities.
/// Offline: return cached entities, or [CacheFailure] / [NetworkFailure].
class RatesRepositoryImpl implements RatesRepository {
  final RatesRemoteDataSource remoteDataSource;
  final RatesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RatesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  @override
  Future<Either<Failure, RateSnapshot>> getLatestRates({
    required String base,
    List<String>? symbols,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDataSource.getLatestRates(
          base: base,
          symbols: symbols,
        );
        final now = DateTime.now();
        await localDataSource.cacheLatestRates(remote, now);
        return Right(remote.toDomain(fetchedAt: now));
      } on ServerException catch (e) {
        // Soft-fail to cache when the network call fails.
        final cached = await _cachedSnapshot();
        if (cached != null) return Right(cached);
        return Left(ServerFailure(e.message));
      }
    }

    final cached = await _cachedSnapshot();
    if (cached != null) return Right(cached);
    return const Left(NetworkFailure());
  }

  Future<RateSnapshot?> _cachedSnapshot() async {
    try {
      final model = await localDataSource.getCachedLatestRates();
      if (model == null) return null;
      final fetchedAt = await localDataSource.getLastUpdatedAt();
      return model.toDomain(fetchedAt: fetchedAt ?? DateTime.now());
    } on CacheException {
      return null;
    }
  }

  @override
  Future<Either<Failure, HistoricalSeries>> getHistoricalSeries({
    required String base,
    required String quote,
    required DateTime start,
    required DateTime end,
  }) async {
    final startStr = _fmt(start);
    final endStr = _fmt(end);

    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDataSource.getHistoricalSeries(
          base: base,
          quote: quote,
          start: start,
          end: end,
        );
        await localDataSource.cacheHistoricalSeries(remote);
        return Right(remote.toDomain());
      } on ServerException catch (e) {
        final cached = await localDataSource.getCachedHistoricalSeries(
          base: base,
          quote: quote,
          startDate: startStr,
          endDate: endStr,
        );
        if (cached != null) return Right(cached.toDomain());
        return Left(ServerFailure(e.message));
      }
    }

    try {
      final cached = await localDataSource.getCachedHistoricalSeries(
        base: base,
        quote: quote,
        startDate: startStr,
        endDate: endStr,
      );
      if (cached != null) return Right(cached.toDomain());
      return const Left(NetworkFailure());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Currency>>> getSupportedCurrencies() async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDataSource.getSupportedCurrencies();
        await localDataSource.cacheCurrencies(remote);
        return Right(remote.map((m) => m.toDomain()).toList());
      } on ServerException catch (e) {
        final cached = await localDataSource.getCachedCurrencies();
        if (cached != null) {
          return Right(cached.map((m) => m.toDomain()).toList());
        }
        return Left(ServerFailure(e.message));
      }
    }

    try {
      final cached = await localDataSource.getCachedCurrencies();
      if (cached != null) {
        return Right(cached.map((m) => m.toDomain()).toList());
      }
      return const Left(NetworkFailure());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> getSelectedCurrencies() async {
    try {
      final list = await localDataSource.getSelectedCurrencies();
      return Right(list);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> addSelectedCurrency(
    String code,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      final upper = code.toUpperCase();
      // Skip duplicates.
      if (current.any((c) => c.code == upper)) {
        return Right(current);
      }
      final updated = [
        ...current,
        SelectedCurrency(code: upper),
      ];
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> removeSelectedCurrency(
    String code,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      final upper = code.toUpperCase();
      // Never allow an empty list.
      if (current.length <= 1) {
        return const Left(
          ValidationFailure('Keep at least one currency selected'),
        );
      }
      var updated = current.where((c) => c.code != upper).toList();
      // If we removed the base, promote the first remaining item.
      if (!updated.any((c) => c.isBase) && updated.isNotEmpty) {
        updated = [
          updated.first.copyWith(isBase: true),
          ...updated.skip(1).map((c) => c.copyWith(isBase: false)),
        ];
      }
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> setBaseCurrency(
    String code,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      final upper = code.toUpperCase();
      var list = current;
      // Ensure the new base is in the list.
      if (!list.any((c) => c.code == upper)) {
        list = [...list, SelectedCurrency(code: upper)];
      }
      final updated = list
          .map((c) => SelectedCurrency(code: c.code, isBase: c.code == upper))
          .toList();
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  /// Saves [orderedCodes] as the new Home-list order while keeping each
  /// currency's base flag. Rejects lists that are not a permutation of the
  /// current selection so we never silently drop or invent codes.
  ///
  /// Example: user drags EUR above USD → `['EUR', 'USD', 'GBP']`.
  @override
  Future<Either<Failure, List<SelectedCurrency>>> reorderSelectedCurrencies(
    List<String> orderedCodes,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      final byCode = {
        for (final c in current) c.code: c,
      };
      final normalized = orderedCodes.map((c) => c.toUpperCase()).toList();

      // Same length + every code already selected = valid reorder permutation.
      // Useful so a stale UI cannot wipe the user's list with a partial order.
      if (normalized.length != current.length ||
          normalized.toSet().length != normalized.length ||
          !normalized.every(byCode.containsKey)) {
        return const Left(
          ValidationFailure('Invalid currency order'),
        );
      }

      final updated = normalized.map((code) => byCode[code]!).toList();
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getLastUpdatedAt() async {
    try {
      return Right(await localDataSource.getLastUpdatedAt());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
