import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../utils/app_colors.dart';
import '../auth/auth_controller.dart';

class ProfileView extends GetView<AdminController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Obx(() => Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        controller.adminName.value.isNotEmpty 
                            ? controller.adminName.value.substring(0, 1).toUpperCase()
                            : 'A',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    controller.adminName.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Role
                  Text(
                    'Administrator (@${controller.adminUsername.value})',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )),
            ),
            const SizedBox(height: 16),

            // Admin Activity Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin Activity Stats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.menu_book,
                          label: 'Books\nUploaded',
                          value: controller.allBooks.length.toString(),
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.people,
                          label: 'Platform\nUsers',
                          value: controller.totalUsers.value,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildActionItem(
                    icon: Icons.person_outline,
                    iconColor: const Color(0xFF7C4DFF),
                    iconBg: const Color(0xFFEDE7F6),
                    title: 'Edited User: Mohamed Dahir',
                    subtitle: '2 hours ago • Updated permissions',
                  ),
                  const SizedBox(height: 12),
                  _buildActionItem(
                    icon: Icons.menu_book,
                    iconColor: AppColors.primary,
                    iconBg: const Color(0xFFE3F2FD),
                    title: 'Uploaded Book: The Great Gatsby',
                    subtitle: '5 hours ago • EPUB format',
                  ),
                  const SizedBox(height: 12),
                  _buildActionItem(
                    icon: Icons.settings,
                    iconColor: const Color(0xFF1976D2),
                    iconBg: const Color(0xFFE3F2FD),
                    title: 'Modified Category: Fiction',
                    subtitle: 'Yesterday • Renamed labels',
                  ),
                  const SizedBox(height: 12),
                  _buildActionItem(
                    icon: Icons.verified_user,
                    iconColor: const Color(0xFF0288D1),
                    iconBg: const Color(0xFFE1F5FE),
                    title: 'Approved Author Application',
                    subtitle: 'Yesterday • Jane Doe',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton.icon(
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
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Books',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          )),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
