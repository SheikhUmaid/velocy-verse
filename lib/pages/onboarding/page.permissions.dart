import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions extends StatelessWidget {
  const Permissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (Platform.isAndroid || Platform.isIOS) {
                  var status = await Permission.location.request();
                  if (status.isGranted) {
                    context.goNamed('/login');
                  } else if (status.isDenied) {
                    Fluttertoast.showToast(
                      msg: "Oops We can not proceed without permission!",
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    );
                  }
                } else {
                  // Skip or handle for other platforms
                  context.goNamed('/login');
                }
              },
              child: Text("Allow Permissions"),
            ),
          ],
        ),
      ),
    );
  }
}
