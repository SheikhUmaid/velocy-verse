import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/pages/login/page.authentication.dart';
import 'package:velocyverse/pages/login/page.login_otp.dart';
import 'package:velocyverse/pages/login/profile_setup/page.profile_setup.dart';
import 'package:velocyverse/pages/onboarding/page.loading.dart';
import 'package:velocyverse/pages/onboarding/page.onboarding.dart';
import 'package:velocyverse/pages/onboarding/page.permissions.dart';
import 'package:velocyverse/pages/user/page.book_ride.dart';
import 'package:velocyverse/pages/user/page.home.dart';
import 'package:velocyverse/pages/user/page.select_location.dart';

class MyRouter {
  final GoRouter routerConfig = GoRouter(
    initialLocation: '/loading',
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
        name: '/selectLocation',
        path: '/selectLocation',
        builder: (BuildContext context, GoRouterState state) {
          return SelectLocation();
        },
      ),
      GoRoute(
        name: '/bookRide',
        path: '/bookRide',
        builder: (BuildContext context, GoRouterState state) {
          return BookRide();
        },
      ),

      GoRoute(
        name: '/loading',
        path: '/loading',
        builder: (BuildContext context, GoRouterState state) {
          return Loading();
        },
      ),
      GoRoute(
        name: '/permissions',
        path: '/permissions',
        builder: (BuildContext context, GoRouterState state) {
          return Permissions();
        },
      ),
      GoRoute(
        name: '/userHome',
        path: '/userHome',
        builder: (BuildContext context, GoRouterState state) {
          return UserHome();
        },
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
}
