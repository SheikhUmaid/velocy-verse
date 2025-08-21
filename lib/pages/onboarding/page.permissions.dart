import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocyverse/utils/svg_image.dart';

class Permissions extends StatelessWidget {
  const Permissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBackgroundImage(),
      bottomNavigationBar: _buildPermissionBottomSheet(context),
    );
  }
}

Widget _buildPermissionBottomSheet(BuildContext context) {
  return SizedBox(
    height: 229,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPermissionReasons(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            var status = await Permission.location.request();
            // Request media/gallery permission
            var mediaStatus = await Permission.photos.request();
            // For Android below 13, use Permission.storage instead
            if (mediaStatus.isDenied) {
              mediaStatus = await Permission.storage.request();
            }

            if (status.isGranted && mediaStatus.isGranted) {
              context.goNamed('/login');
            } else if (status.isDenied && mediaStatus.isDenied) {
              Fluttertoast.showToast(
                msg: "Oops We can not procced without permission!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          child: Text(
            "Allow Permissions",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPermissionReasons() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildPermissionItem(
        icon: SvgImage.location.value,
        text: "To locate you and get rides easily",
      ),
      const SizedBox(height: 12),
      // Phone permission UI — commented out for now
      _buildPermissionItem(
        icon: SvgImage.phone.value,
        text: "To verify your account and secure it",
      ),
    ],
  );
}

Widget _buildPermissionItem({required String icon, required String text}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [SvgPicture.asset(icon), const SizedBox(width: 12), Text(text)],
  );
}

Widget _buildBackgroundImage() {
  return Image.asset(
    AppImage.permission.value,
    width: double.infinity,
    fit: BoxFit.fill,
  );
}
