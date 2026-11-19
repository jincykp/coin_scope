import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_bloc.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

import 'features/watchlist/data/data_sources/watchlist_local_data_source.dart';
import 'features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'features/watchlist/domain/usecases/get_watchlist.dart';
import 'features/watchlist/domain/usecases/toggle_watchlist.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = WatchlistRepositoryImpl(
      localDataSource: WatchlistLocalDataSource(),
    );

    return BlocProvider(
      create: (_) => WatchlistBloc(
        getWatchlist: GetWatchlist(repository: repository),
        toggleWatchlist: ToggleWatchlist(repository: repository),
      )..add(const LoadWatchlistEvent()),
      child: MaterialApp(
        title: 'CoinScope',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
