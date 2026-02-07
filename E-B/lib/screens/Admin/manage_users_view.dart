import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../utils/app_colors.dart';
import 'add_user_view.dart';

class ManageUsersView extends GetView<AdminController> {
  const ManageUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Manage Users',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Get.to(() => const AddUserView());
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search users by username',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Obx(() => _buildFilterTab(
                  'All Users',
                  controller.selectedUserFilter.value == 'All Users',
                )),
                const SizedBox(width: 16),
                Obx(() => _buildFilterTab(
                  'Recently Joined',
                  controller.selectedUserFilter.value == 'Recently Joined',
                )),
              ],
            ),
          ),
          const SizedBox(height: 1),
          
          // Users List
          Expanded(
            child: Obx(() {
                 final users = controller.filteredUsers;
                 if (users.isEmpty) {
                     return const Center(child: Text("No users found"));
                 }
                 return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildUserCard(
                                user,
                            ),
                        );
                    },
                 );
            }),
          ),
        ],
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
                label: 'E-Books',
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

  Widget _buildFilterTab(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.changeUserFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    String username = user['username'] ?? 'Unknown';
    String initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    // String joinedDate = user['createdAt'] ?? 'Date Unknown'; 
    String joinedDate = 'JOINED: RECENTLY'; // formatting needed if date string

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
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
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
                      username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['fullname'] ?? 'No Name',
                       style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      user['role']?.toString().toUpperCase() ?? 'USER',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              // Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          // Stats and Actions
          Row(
            children: [
              const Spacer(),
              // Edit Button
              TextButton.icon(
                onPressed: () {
                    // Navigate to Edit User (reusing AddUserView with data)
                    Get.to(() => AddUserView(userData: user));
                },
                icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              // Delete Button
              TextButton.icon(
                onPressed: () {
                    if (user['_id'] != null) {
                        controller.deleteUser(user['_id']);
                    }
                },
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                label: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
