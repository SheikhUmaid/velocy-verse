import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/driver/mainPages/page.driverReport.dart';
import 'package:velocyverse/pages/driver/mainPages/recent%20rides/page.driverRecentRides.dart';
import 'package:velocyverse/pages/driver/main_pages/screen.driver_home.dart';
import 'package:velocyverse/providers/driver/provider.driver_profile.dart';
import 'package:velocyverse/services/secure_storage_service.dart';
import 'package:velocyverse/utils/util.logout.dart';

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

      //
      //  bool success = await Provider.of<DriverProfileProvider>(
      //   context,
      //   listen: false,
      // ).getDriverProfile();
      //
      if (!success) {
        debugPrint("Failed to fetch driver profile");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DriverProfileProvider>(context);
    return Scaffold(
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
                  child: Icon(CupertinoIcons.person, color: Colors.black),
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
              leading: Icon(CupertinoIcons.settings, color: Colors.black),
              title: Text('Help & support'),
            ),

            ListTile(
              leading: Icon(Icons.support_agent, color: Colors.black),
              title: Text('Help & support'),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout'),
              onTap: () {
                logout();
                context.goNamed('/loading');
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
    );
  }

  _logOut() async {
    await SecureStorage.clearTokens();
    context.go('/loading');
  }
}
