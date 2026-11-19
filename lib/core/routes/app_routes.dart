import 'package:flutter/material.dart';

import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/coin_details/presentation/pages/coin_details_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String coinDetails = '/coin-details';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashPage(),
        home: (context) => const HomeScreen(),

        coinDetails: (context) {
          final coinId =
              ModalRoute.of(context)!.settings.arguments as String;

          return CoinDetailsScreen(coinId: coinId);
        },
      };
}