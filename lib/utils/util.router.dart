import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/pages/login/page.authentication.dart';
import 'package:velocyverse/pages/login/page.login_otp.dart';
import 'package:velocyverse/pages/login/profile_setup/page.profile_setup.dart';
import 'package:velocyverse/pages/onboarding/page.onboarding.dart';
import 'package:velocyverse/pages/onboarding/page.permissions.dart';
import 'package:velocyverse/pages/user_app/home/user_main_screen.dart';
import 'package:velocyverse/pages/user_app/page.home.dart';

class MyRouter {
  static final MyRouter _instance = MyRouter._internal();

  factory MyRouter() => _instance;

  late final GoRouter routerConfig;

  MyRouter._internal() {
    routerConfig = GoRouter(
      initialLocation: '/permissions',
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        GoRoute(
          name: '/login',
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => AuthScreen(),
        ),
        GoRoute(
          name: '/permissions',
          path: '/permissions',
          builder: (BuildContext context, GoRouterState state) => Permissions(),
        ),
        GoRoute(
          name: '/userHome',
          path: '/userHome',
          builder: (BuildContext context, GoRouterState state) =>
              UserMainScreen(),
        ),
        GoRoute(
          name: '/loginOTP',
          path: '/loginOTP',
          builder: (BuildContext context, GoRouterState state) {
            String phoneNumber = state.extra as String;
            return LoginOTP(phoneNumber: phoneNumber);
          },
        ),
        GoRoute(
          name: '/complete_profile',
          path: '/complete_profile',
          builder: (BuildContext context, GoRouterState state) =>
              PageCompleteProfile(),
        ),
        GoRoute(
          name: '/onboarding',
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) => Onboarding(),
        ),
      ],
    );
  }
}
