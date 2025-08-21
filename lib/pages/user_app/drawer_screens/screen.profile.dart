import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/providers/user/provider.rider_profile.dart';
import 'package:velocyverse/utils/util.logout.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<RiderProfileProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text("Settings")),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User Profile Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () => context.pushNamed("/riderUpdateProfile"),
                    child: Row(
                      children: [
                        // Profile Avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Consumer<RiderProfileProvider>(
                              builder: (_, prov, __) {
                                // prov.getRiderProfile();
                                return Image.network(
                                  profileProvider.profileURL ?? "",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileProvider.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profileProvider.contactNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow Icon
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),

                // Settings Options
                Column(
                  children: [
                    _buildSettingItem(
                      icon: Icons.tune,
                      title: 'Preferences',
                      onTap: () {
                        // _onPreferencesTap();
                      },
                    ),

                    _buildSettingItem(
                      icon: Icons.language,
                      title: 'Language & Region',
                      subtitle: 'English (US)',
                      onTap: () {},
                    ),
                  ],
                ),

                // Log Out Section
                Expanded(child: SizedBox()),

                GestureDetector(
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade700, size: 24),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            if (subtitle != null) ...[
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 8),
            ],

            Icon(Icons.chevron_right, color: Colors.grey.shade500, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.snackbar(
          'Language Changed',
          'Language changed to $language',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.blue : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performLogout(context);
              },
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.red.shade600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    // Perform logout logic here

    logout();
    context.goNamed('/loading');
    // Navigate to login screen
    // Get.offAllNamed('/login');
  }
}
