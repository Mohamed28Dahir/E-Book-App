import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import 'dashboard_view.dart';
import 'manage_books_view.dart';
import 'manage_users_view.dart';
import 'profile_view.dart';

class AdminMainView extends GetView<AdminController> {
  const AdminMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          return const DashboardView();
        case 1:
          return const ManageBooksView();
        case 2:
          return const ManageUsersView();
        case 3:
          return const ProfileView();
        default:
          return const DashboardView();
      }
    });
  }
}
