import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'home_view.dart';
import 'library_view.dart';
import 'favorites_view.dart';
import 'user_profile_view.dart';

class UserMainView extends GetView<UserController> {
  const UserMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const LibraryView(),
      const FavoritesView(),
      const UserProfileView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF1E3A8A),
            unselectedItemColor: const Color(0xFF94A3B8),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_outlined),
                activeIcon: Icon(Icons.library_books),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
