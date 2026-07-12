import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/locator.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/nerkhak_bottom_nav.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_bloc.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_event.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_state.dart';
import 'package:currency_converter/features/currency_detail/presentation/pages/currency_detail_page.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_bloc.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_event.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_state.dart';
import 'package:currency_converter/features/rates/presentation/pages/home_page.dart';
import 'package:currency_converter/features/settings/presentation/pages/settings_page.dart';

/// App root shell: one persistent bottom nav + [IndexedStack] tab bodies.
///
/// Tabs stay alive when switching (no route push / nav rebuild). Chart tab
/// reloads only when the home list's base/quote pair changed.
///
/// Example:
/// ```dart
/// PageName.home: (_) => const MainShellPage(),
/// ```
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  /// 0 = Convert, 1 = Chart, 2 = Settings.
  int _currentIndex = 0;

  late final HomeBloc _homeBloc;
  late final DetailBloc _detailBloc;

  @override
  void initState() {
    super.initState();
    // Own tab BLoCs at the shell so IndexedStack children share stable state.
    _homeBloc = locator<HomeBloc>()..add(const HomeEvent.started());
    _detailBloc = locator<DetailBloc>()
      ..add(const DetailEvent.started(code: 'EUR', baseCode: 'USD'));
  }

  @override
  void dispose() {
    _homeBloc.close();
    _detailBloc.close();
    super.dispose();
  }

  /// Switches the visible tab. When opening Chart, sync pair from Home first.
  void _onTabSelected(int index) {
    if (index == _currentIndex) return;

    // Chart tab: refresh series only if home selection differs from detail.
    if (index == 1) {
      _syncChartFromHomeIfNeeded();
    }

    setState(() => _currentIndex = index);
  }

  /// Reads base + first non-base from Home and restarts Detail when they differ.
  void _syncChartFromHomeIfNeeded() {
    final load = _homeBloc.state.load;
    if (load is! HomeLoadCompleted || load.selected.isEmpty) return;

    final base = load.selected
        .firstWhere((c) => c.isBase, orElse: () => load.selected.first)
        .code;
    final quote = load.selected
        .firstWhere((c) => !c.isBase, orElse: () => load.selected.first)
        .code;

    final detailLoad = _detailBloc.state.load;
    // Skip restart when Chart already shows the same pair (avoids flicker).
    if (detailLoad is DetailLoadCompleted &&
        detailLoad.code == quote &&
        detailLoad.baseCode == base) {
      return;
    }

    _detailBloc.add(DetailEvent.started(code: quote, baseCode: base));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>.value(value: _homeBloc),
        BlocProvider<DetailBloc>.value(value: _detailBloc),
      ],
      child: GScaffold(
        // Notch bar floats over tab content; each tab keeps its own AppBar.
        extendBody: true,
        bottomNavigationBar: NerkhakBottomNav(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            // embedded: reuse shell BLoCs; do not create nested providers.
            HomePage(embedded: true),
            CurrencyDetailPage(embedded: true),
            SettingsPage(),
          ],
        ),
      ),
    );
  }
}
