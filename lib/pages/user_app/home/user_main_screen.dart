import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocyverse/pages/user_app/corporate/corporate_screen.dart';
import 'package:velocyverse/pages/user_app/page.home.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/rental_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/ride_share_screen.dart';
import 'package:velocyverse/utils/svg_image.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    UserHome(),
    RentalScreen(),
    RideShareScreen(),
    CorporateScreen(),
  ];

  BottomNavigationBarItem _buildNavItem(
    String assetPath,
    String label,
    int index,
  ) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        height: 20,
        color: isSelected ? Colors.black : Colors.grey,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          _buildNavItem(SvgImage.bookRide.value, 'Book Ride', 0),
          _buildNavItem(SvgImage.rental.value, 'Rental', 1),
          _buildNavItem(SvgImage.carPool.value, 'Ride Share', 2),
          _buildNavItem(SvgImage.corparate.value, 'Corporate', 3),
        ],
      ),
    );
  }
}
