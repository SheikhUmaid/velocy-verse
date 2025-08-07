import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/utils/util.is_logged_in.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    bool loggedIn = await isLoggedin();

    if (context.mounted) {
      if (loggedIn) {
        context.goNamed("/userHome");
      } else {
        context.goNamed("/permissions");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
