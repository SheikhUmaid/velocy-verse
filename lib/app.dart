import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/networking/apiservices.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/provider/rental_provider.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/rental_api_service/rental_api_service.dart';
import 'package:VelocyTaxzz/providers/driver/provider.driver_profile.dart';
import 'package:VelocyTaxzz/providers/driver/provider.earningNreport.dart';
import 'package:VelocyTaxzz/providers/driver/provider.rideHistory.dart';

import 'package:VelocyTaxzz/providers/driver/provider.driver.dart';
import 'package:VelocyTaxzz/providers/login/provider.authentication.dart';
import 'package:VelocyTaxzz/providers/payment/provider.payment.dart';
import 'package:VelocyTaxzz/providers/provider.loader.dart';
import 'package:VelocyTaxzz/providers/user/provider.ride.dart';
import 'package:VelocyTaxzz/providers/user/provider.rider_profile.dart';
import 'package:VelocyTaxzz/utils/util.global_loader.dart';
import 'package:VelocyTaxzz/utils/util.router.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  final RentalApiService rentalApiService;
  const MyApp({super.key, required this.rentalApiService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => LoaderProvider()),
        ChangeNotifierProvider(
          create: (_) => DriverProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => RideProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => RentalProvider(rentalApiService)..fetchVehicles(),
        ),
        ChangeNotifierProvider(create: (_) => RecentRidesProvider()),

        ChangeNotifierProvider(create: (_) => EaningsNreportsProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(
          create: (_) => DriverProfileProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              RiderProfileProvider(apiService: ApiService())..getRiderProfile(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Velocy Verse',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFFF5F5F5),
            centerTitle: true,
            surfaceTintColor: const Color(0xFFF5F5F5),
            elevation: 0.2,
            shadowColor: Colors.grey,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ),
        routerConfig: MyRouter.routerConfig,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(children: [child!, GlobalLoader()]);
        },
      ),
    );
  }
}
