import 'package:flutter/material.dart';
import 'package:wasteapp/features/auth/presentation/pages/register_screen.dart';
import 'package:wasteapp/features/auth/presentation/pages/welcome_screen.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/presentation/pages/home_screen.dart';
import 'package:wasteapp/features/home/presentation/pages/item_detail_view.dart';
import 'package:wasteapp/features/home/presentation/pages/items_grid_view.dart';

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

  static const String toEventCalenderScreen = 'toEventCalenderScreen';
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
                ? settings.arguments as DetailModel
                : DetailModel(
                  id: "",
                  title: "",
                  location: "",
                  locationCategory: "",
                  category: "",
                  season: "",
                  rating: 0.0,
                  imageUrls: [],
                  description: "",
                  suggestionNote: "",
                  isFavourite: false,
                );

        return MaterialPageRoute(
          builder: (_) => ItemDetailPage(detailModel: args),
        );

      case ScreenRoutes.toRegisterScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      default:
        return null;
    }
  }
}
