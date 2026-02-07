import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'edit_profile_view.dart';
import 'reading_history_view.dart';
import '../auth/auth_controller.dart';

class UserProfileView extends GetView<UserController> {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => controller.changeTab(0),
                      color: const Color(0xFF1E293B),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'User Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, size: 20, color: Color(0xFFEF4444)),
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.put(AuthController()).logout();
                                },
                                child: const Text('Logout', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Profile Image/Avatar
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Obx(() => Text(
                          controller.userName.value.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        )),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // User Info
              Obx(() => Text(
                    controller.userName.value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  )),
              const SizedBox(height: 4),
              const Text(
                'Member since March 2023',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              // Reading Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'READING STATS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                      children: [
                        _buildStatCard(
                          controller.readingHistory.length.toString(),
                          'BOOKS READ',
                          Icons.menu_book,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          controller.favoriteBooks.length.toString(),
                          'FAVORITES',
                          Icons.favorite,
                        ),
                      ],
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Account Settings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACCOUNT SETTINGS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            icon: Icons.person,
                            iconBgColor: const Color(0xFFDBEAFE),
                            iconColor: const Color(0xFF1E3A8A),
                            title: 'Edit Profile',
                            onTap: () => Get.to(() => const EditProfileView()),
                          ),
                          const Divider(height: 1, indent: 64),
                          _buildSettingItem(
                            icon: Icons.history,
                            iconBgColor: const Color(0xFFF1F5F9),
                            iconColor: const Color(0xFF334155),
                            title: 'Reading History',
                            onTap: () => Get.to(() => const ReadingHistoryView()),
                          ),
                          const Divider(height: 1, indent: 64),
                          _buildSettingItem(
                            icon: Icons.logout,
                            iconBgColor: const Color(0xFFFEF2F2),
                            iconColor: const Color(0xFFEF4444),
                            title: 'Logout',
                            isLogout: true,
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.put(AuthController()).logout();
                                      },
                                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: const Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF1E293B),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isLogout ? const Color(0xFFEF4444).withOpacity(0.5) : const Color(0xFFCBD5E1),
      ),
    );
  }
}
