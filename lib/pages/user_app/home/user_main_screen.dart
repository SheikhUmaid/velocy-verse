import 'package:flutter/material.dart';
import 'package:velocyverse/pages/user_app/corporate/corporate_screen.dart';
import 'package:velocyverse/pages/user_app/home/user_home_scree.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/rental_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/ride_share_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    UserHomeScreen(),
    RentalScreen(),
    RideShareScreen(),
    CorporateScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Book Ride',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.time_to_leave),
            label: 'Rental',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Ride Share'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Corporate',
          ),
        ],
      ),
    );
  }
}
