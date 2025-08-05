import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/pages/login/page.authentication.dart';
import 'package:velocyverse/pages/login/profile_setup/page.profile_setup.dart';
import 'package:velocyverse/pages/onboarding/page.onboarding.dart';
import 'package:velocyverse/providers/login/provider.authentication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(apiService: ApiService()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Velocy Verse',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
          // textTheme: GoogleFonts.interTextTheme(),
          // colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        ),
        // theme: ThemeData.dark(),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/onboarding',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      name: '/login',
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return AuthScreen();
      },
    ),

    GoRoute(
      name: '/complete_profile',
      path: '/complete_profile',
      builder: (BuildContext context, GoRouterState state) {
        return PageCompleteProfile();
      },
    ),

    GoRoute(
      name: '/onboarding',
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return Onboarding();
      },
    ),
  ],
);
