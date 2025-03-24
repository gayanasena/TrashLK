import 'package:flutter/material.dart';
import 'package:wasteapp/features/auth/presentation/pages/register_screen.dart';
import 'package:wasteapp/features/auth/presentation/pages/welcome_screen.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/presentation/pages/category_finder_view.dart';
import 'package:wasteapp/features/home/presentation/pages/home_screen.dart';
import 'package:wasteapp/features/home/presentation/pages/item_detail_view.dart';
import 'package:wasteapp/features/home/presentation/pages/items_grid_view.dart';
import 'package:wasteapp/features/home/presentation/pages/near_by_bins.dart';
import 'package:wasteapp/features/home/presentation/pages/qr_scan_view.dart';

import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/splash_screen.dart';

class ScreenRoutes {
  static const String toSplashScreen = 'toSplashScreen';

  static const String toSettingsScreen = 'toSettingsScreen';

  static const String toLoginScreen = 'toLoginScreen';

  static const String toHomeScreen = 'toHomeScreen';

  static const String toItemGridScreen = 'toItemGridScreen';

  static const String toItemDetailScreen = 'toItemDetailScreen';

  static const String toWelcomeScreen = 'toWelcomeScreen';

  static const String toRegisterScreen = 'toRegisterScreen';

  static const String toQRScanScreen = 'toQRScanScreen';

  static const String toCategoryFinderScreen = 'toCategoryFinderScreen';

  static const String toNearByBinsScreen = 'toNearByBinsScreen';
}

class Router {
  static bool isGuestUser = true;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ScreenRoutes.toSplashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case ScreenRoutes.toWelcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case ScreenRoutes.toLoginScreen:
        // var args = settings.arguments != null ? settings.arguments as Map : {};
        // bool isForceLogout = args["isForceLogout"] ?? false;

        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case ScreenRoutes.toHomeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case ScreenRoutes.toItemGridScreen:
        var args =
            settings.arguments != null ? settings.arguments as String : "";

        return MaterialPageRoute(builder: (_) => ItemGridView(gridType: args));

      case ScreenRoutes.toItemDetailScreen:
        var args =
            settings.arguments != null
                ? settings.arguments as CommonDetailModel
                : CommonDetailModel(
                  id: "",
                  title: "",
                  location: "",
                  subLocation: "",
                  category: "",
                  price: "",
                  percentage: 0.0,
                  imageUrls: [],
                  description: "",
                  notes: "",
                  isFlag: false,
                );

        return MaterialPageRoute(
          builder: (_) => ItemDetailPage(detailModel: args),
        );

      case ScreenRoutes.toRegisterScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case ScreenRoutes.toQRScanScreen:
        return MaterialPageRoute(builder: (_) => const QrScanView());

      case ScreenRoutes.toCategoryFinderScreen:
        return MaterialPageRoute(builder: (_) => const CategoryFinderView());

      case ScreenRoutes.toNearByBinsScreen:
        return MaterialPageRoute(builder: (_) => const NearByBins());

      default:
        return null;
    }
  }
}
