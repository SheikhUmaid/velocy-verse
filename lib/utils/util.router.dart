import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/pages/login/page.authentication.dart';
import 'package:velocyverse/pages/login/page.login_otp.dart';
import 'package:velocyverse/pages/onboarding/page.loading.dart';
import 'package:velocyverse/pages/onboarding/page.permissions.dart';
import 'package:velocyverse/pages/user_app/book_ride/screen.confirm_location.dart';
import 'package:velocyverse/pages/user_app/book_ride/screen.select_vehicle.dart';
import 'package:velocyverse/pages/user_app/book_ride/screen.waiting_for_driver.dart';
import 'package:velocyverse/pages/user_app/home/user_main_screen.dart';
import 'package:velocyverse/pages/user_app/book_ride/page.select_location.dart';

class MyRouter {
  static GoRouter routerConfig = GoRouter(
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
        name: '/waitingForDriver',
        path: '/waitingForDriver',
        builder: (BuildContext context, GoRouterState state) {
          return WaitingDriverScreen();
        },
      ),
      GoRoute(
        name: '/selectVehicle',
        path: '/selectVehicle',
        builder: (BuildContext context, GoRouterState state) {
          return SelectVehicleScreen();
        },
      ),
      GoRoute(
        name: '/selectLocation',
        path: '/selectLocation',
        builder: (BuildContext context, GoRouterState state) {
          int flag = state.extra as int;
          return SelectLocation(pickDropFlag: flag);
        },
      ),
      GoRoute(
        name: '/bookRide',
        path: '/bookRide',
        builder: (BuildContext context, GoRouterState state) {
          return ConfirmLocationScreen();
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
          return UserMainScreen();
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
    ],
  );
}
