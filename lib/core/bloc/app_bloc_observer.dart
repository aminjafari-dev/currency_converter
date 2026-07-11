import 'package:flutter_bloc/flutter_bloc.dart';

/// Simple [BlocObserver] for debug logging of transitions and errors.
///
/// Wired in [main] via [Bloc.observer]. Safe to leave enabled in debug builds.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // Helpful when tracing state flow during development.
    // ignore: avoid_print
    print('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // ignore: avoid_print
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
