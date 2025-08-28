import 'package:flutter/material.dart';
import 'package:VelocyTaxzz/pages/driver/mainPages/page.driverHome.dart';
import 'package:VelocyTaxzz/pages/driver/mainPages/recent%20rides/page.driverRecentRides.dart';
import 'package:VelocyTaxzz/pages/driver/mainPages/page.driverReport.dart';

class DriverMain extends StatefulWidget {
  const DriverMain({super.key, this.pgNo = 0});
  final int pgNo;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
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
}
