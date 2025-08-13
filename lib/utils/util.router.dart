import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';import 'package:velocyverse/pages/driver/ride/scree.drop_navigation.dart';
import 'package:velocyverse/pages/driver/ride/screen.pickup_navigation.dart';
import 'package:velocyverse/pages/driver/ride/screen.ride_detail.dart';
import 'package:velocyverse/pages/driver/screen.driver_main.dart';
import 'package:velocyverse/pages/login/diver/screen.document_upload.dart';
import 'package:velocyverse/pages/driver/mainPages/recent%20rides/page.recentRideDetails.dart';
import 'package:velocyverse/pages/driver/mainPages/ride/page.navPickUp.dart';
import 'package:velocyverse/pages/driver/mainPages/ride/page.rideDetails.dart';
import 'package:velocyverse/pages/driver/mainPages/ride/page.navDropOff.dart';
import 'package:velocyverse/pages/driver/mainPages/ride/page.ridePayment.dart';
import 'package:velocyverse/pages/driver/mainPages/ride/page.rideComplete.dart';
import 'package:velocyverse/pages/driver/page.driverMain.dart';
import 'package:velocyverse/pages/login/page.authentication.dart';
import 'package:velocyverse/pages/login/page.login_otp.dart';
import 'package:velocyverse/pages/login/diver/screen.driver_registeration.dart';
import 'package:velocyverse/pages/login/profile_setup/page.profile_setup.dart';
import 'package:velocyverse/pages/onboarding/page.loading.dart';
import 'package:velocyverse/pages/onboarding/page.onboarding.dart';
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
        name: '/dropOffNavigation',
        path: '/dropOffNavigation',
        builder: (BuildContext context, GoRouterState state) {
          return NavigationDropOff();
        },
      ),
      GoRoute(
        name: '/pickUpNavigation',
        path: '/pickUpNavigation',
        builder: (BuildContext context, GoRouterState state) {
          return NavigationPickUp();
        },
      ),
      GoRoute(
        name: '/rideDetail',
        path: '/rideDetail',
        builder: (BuildContext context, GoRouterState state) {
          return RideDetailsScreen();
        },
      ),
      GoRoute(
        name: '/driverMain',
        path: '/driverMain',
        builder: (BuildContext context, GoRouterState state) {
          return DriverMain();
        },
      ),
      GoRoute(
        name: '/documentVerification',
        path: '/documentVerification',
        builder: (BuildContext context, GoRouterState state) {
          return DocumentVerificationScreen();
        },
      ),
      GoRoute(
        name: '/driverRegisteration',
        path: '/driverRegisteration',
        builder: (BuildContext context, GoRouterState state) {
          return DriverRegisterationScreen();
        },
      ),
      GoRoute(
        name: '/onboarding',
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) {
          return Onboarding();
        },
      ),

      GoRoute(
        name: '/completeProfile',
        path: '/completeProfile',
        builder: (BuildContext context, GoRouterState state) {
          return PageCompleteProfile();
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
      GoRoute(
        path: '/driverMain',
        name: '/driverMain',
        builder: (context, state) {
          return const DriverMain();
        },
      ),
      GoRoute(
        path: '/rideDetails',
        name: '/rideDetails',
        builder: (context, state) {
          return const RideDetailsScreen();
        },
      ),
      GoRoute(
        path: '/navPickUp',
        name: '/navPickUp',
        builder: (context, state) {
          return NavigationPickUp();
        },
      ),
      GoRoute(
        path: '/navDropOff',
        name: '/navDropOff',
        builder: (context, state) {
          return NavigationDropOff();
        },
      ),
      GoRoute(
        path: '/ridePayment',
        name: '/ridePayment',
        builder: (context, state) {
          return RidePayment();
        },
      ),
      GoRoute(
        path: '/rideComplete',
        name: '/rideComplete',
        builder: (context, state) {
          return RideComplete();
        },
      ),
      GoRoute(
        path: '/recentRideDetails',
        name: '/recentRideDetails',
        builder: (context, state) {
          return RecentRideDetails();
        },
      ),
    ],
  );
}
