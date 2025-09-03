import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:VelocyTaxzz/components/base/component.primary_button.dart';
import 'package:VelocyTaxzz/pages/user_app/page.home.dart';
import 'package:VelocyTaxzz/utils/util.logout.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UserHome());
  }
}
