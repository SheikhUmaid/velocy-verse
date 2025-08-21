import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/models/model.driverDetails.dart';
import 'package:velocyverse/providers/driver/provider.driver_profile.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  bool _darkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      print("Fetching driver profile");
      bool success = await Provider.of<DriverProfileProvider>(
        context,
        listen: false,
      ).getDriverProfile();
      if (!success) {
        debugPrint("Failed to fetch driver profile");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DriverProfileProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          print(
            'provider details = ${profileProvider.profileDetails!.vehicleInfo?.id}',
          );
          if (profileProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (profileProvider.profileDetails == null ||
              profileProvider.profileDetails?.vehicleInfo == null) {
            return Center(child: Text('Something went wrong'));
          } else {
            final profileDetail = profileProvider.profileDetails;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // User Profile Section
                  _buildUserProfileTile(profileDetail!),
                  const SizedBox(height: 24),

                  // Vehicle Information Section
                  _buildVehicleSection(profileDetail),

                  const SizedBox(height: 24),

                  // Settings Options
                  // _buildSettingsOptions(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserProfileTile(DriverDetailsModel profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push('/driverUpdateProfile', extra: profile);
        },
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
              backgroundImage: profile.profileImage != null
                  ? NetworkImage(profile.profileImage!)
                  : null,
              child: profile.profileImage == null
                  ? Icon(Icons.person, size: 28, color: Colors.grey[600])
                  : null,
            ),

            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.username!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSection(DriverDetailsModel profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vehicle Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                // GestureDetector(
                //   onTap: () => _onAddVehicleTap(),
                //   child: Text(
                //     'Add Vehicle',
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: Colors.blue[600],
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: Colors.grey[200],
            indent: 16,
            endIndent: 16,
          ),

          // // Vehicle List
          // ..._vehicles.asMap().entries.map((entry) {
          //   final index = entry.key;
          //   final vehicle = entry.value;
          //   final isLast = index == _vehicles.length - 1;

          //   return _buildVehicleTile(vehicle, isLast);
          // }).toList(),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Vehicle Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          CupertinoIcons.car_detailed,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Vehicle Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.vehicleInfo!.carName ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.vehicleInfo!.vehicleNumber ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow Icon
                      // Icon(
                      //   Icons.chevron_right,
                      //   color: Colors.grey[400],
                      //   size: 20,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleTile(VehicleInfo vehicle, bool isLast) {
    return InkWell(
      onTap: () => _onVehicleTap(vehicle),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                // Vehicle Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.car_detailed,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(width: 12),

                // Vehicle Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.carName ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vehicle.vehicleNumber ?? '',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),

            // Divider (except for last item)
            if (!isLast)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 44),
                child: Divider(height: 1, color: Colors.grey[200]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'English',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
            onTap: () => _onLanguageTap(),
          ),

          _buildDivider(),

          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
            onTap: () => _onNotificationsTap(),
          ),

          _buildDivider(),

          _buildSettingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch.adaptive(
              value: _darkMode,
              onChanged: (value) => _onDarkModeToggle(value),
              activeColor: Colors.blue[600],
            ),
            onTap: () => _onDarkModeToggle(!_darkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 54, // Align with text start
      endIndent: 16,
    );
  }

  // Event Handlers
  void _onAddVehicleTap() {
    // Navigate to add vehicle screen
    debugPrint('Add Vehicle tapped');
  }

  void _onVehicleTap(VehicleInfo vehicle) {
    // Navigate to vehicle details screen
    debugPrint('Vehicle tapped: ${vehicle.carName}');
  }

  void _onLanguageTap() {
    // Navigate to language selection screen
    debugPrint('Language tapped');
  }

  void _onNotificationsTap() {
    // Navigate to notifications settings screen
    debugPrint('Notifications tapped');
  }

  void _onDarkModeToggle(bool value) {
    setState(() {
      _darkMode = value;
    });
    // Apply dark mode theme
    debugPrint('Dark Mode: $value');
  }
}
