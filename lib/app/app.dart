import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasteapp/features/home/presentation/cubit/cubit/page_indicator_cubit.dart';
import 'package:wasteapp/routes/routes.dart' as router;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    // Observe app state
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // save AppInstance()
    } else if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.inactive) {
      // save AppInstance()
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // save AppInstance()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageIndicatorCubit>(
          create: (context) => PageIndicatorCubit(),
        ),
      ],
      child: const MaterialApp(
        title: 'TrashLK',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.Router.generateRoute,
        initialRoute: router.ScreenRoutes.toSplashScreen,
      ),
    );
  }
}
