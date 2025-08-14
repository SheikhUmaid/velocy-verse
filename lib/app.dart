import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';
import 'package:velocyverse/pages/user_app/rental/rental_api_service/rental_api_service.dart';
import 'package:velocyverse/providers/login/provider.authentication.dart';
import 'package:velocyverse/providers/provider.loader.dart';
import 'package:velocyverse/utils/util.global_loader.dart';
import 'package:velocyverse/utils/util.router.dart';

class MyApp extends StatelessWidget {
  final RentalApiService rentalApiService;

  const MyApp({super.key, required this.rentalApiService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (context) => LoaderProvider()),
        ChangeNotifierProvider(
          create: (_) => RentalProvider(rentalApiService)..fetchVehicles(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Velocy Verse',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            surfaceTintColor: Colors.white,
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
