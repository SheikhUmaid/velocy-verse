import 'package:VelocyTaxzz/providers/driver/provider.earningNreport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/pages/driver/mainPages/page.driverReport.dart';
import 'package:VelocyTaxzz/pages/driver/mainPages/recent%20rides/page.driverRecentRides.dart';
import 'package:VelocyTaxzz/pages/driver/main_pages/screen.driver_home.dart';
import 'package:VelocyTaxzz/providers/driver/provider.driver_profile.dart';
import 'package:VelocyTaxzz/utils/util.logout.dart';

class DriverMain extends StatefulWidget {
  const DriverMain({super.key});

  @override
  State<DriverMain> createState() => _DriverMainState();
}

class _DriverMainState extends State<DriverMain> {
  int _selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = const [
    DriverHome(),
    DriverReports(),
    DriverRecentRides(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      print("Fetching driver profile");
      bool success = (await Provider.of<DriverProfileProvider>(
        context,
        listen: false,
      ).getDriverProfile());
      if (!success) {
        debugPrint("Failed to fetch driver profile");
      }
    });
  }

  DateTime? _lastBackPressed;
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0; // Go back to home
      });
      return false; // Don't exit
    }

    DateTime now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Press back again to exit")));
      return false; // Wait for second press
    }
    return true; // Exit app on second back within 2 sec
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DriverProfileProvider>(context);
    final profile = profileProvider.profileDetails;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(child: _screens[_selectedIndex]),
        drawer: Drawer(
          shape: RoundedRectangleBorder(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: profile!.profileImage != null
                        ? NetworkImage(profile.profileImage!)
                        : null,
                    child: profile.profileImage == null
                        ? Icon(Icons.person, size: 28, color: Colors.grey[600])
                        : null,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profileProvider.profileDetails?.username ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${profileProvider.profileDetails?.email}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              ListTile(
                leading: Icon(CupertinoIcons.person, color: Colors.black),
                title: Text('Profile settings'),
                onTap: () {
                  context.push('/driverProfile');
                },
              ),
              ListTile(
                onTap: () {
                  context.push('/privacyPolicy');
                },
                leading: Icon(
                  CupertinoIcons.shield_lefthalf_fill,
                  color: Colors.black,
                ),
                title: Text('Privacy policy'),
              ),
              ListTile(
                onTap: () {
                  context.goNamed('/driverTnC');
                },
                leading: Icon(
                  CupertinoIcons.folder_circle,
                  color: Colors.black,
                ),
                title: Text('Terms & Conditions'),
              ),

              ListTile(
                onTap: () {
                  context.push('/helpNsupport');
                },
                leading: Icon(Icons.support_agent, color: Colors.black),
                title: Text('Help & support'),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.black),
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              logout();
                              context.goNamed('/loading');
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_open_sharp),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_repair_rounded),
              label: 'Recent Rides',
            ),
          ],
        ),
      ),
    );
  }
}
