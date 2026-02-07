import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../utils/app_colors.dart';
import 'add_book_view.dart';

class ManageBooksView extends GetView<AdminController> {
  const ManageBooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Manage Books',
          style: TextStyle(
            color: Colors.black,
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
                Get.to(() => const AddBookView());
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search title, author or ISBN...',
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
          // Category Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: [
                      _buildCategoryTab('All', controller.selectedCategory.value == 'All'),
                      _buildCategoryTab('Story', controller.selectedCategory.value == 'Story'),
                      _buildCategoryTab('Love', controller.selectedCategory.value == 'Love'),
                      _buildCategoryTab('Education', controller.selectedCategory.value == 'Education'),
                      _buildCategoryTab('Islamic', controller.selectedCategory.value == 'Islamic'),
                      _buildCategoryTab('History', controller.selectedCategory.value == 'History'),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 1),
          // Books List
          Expanded(
            child: Obx(() {
              final books = controller.filteredBooks;
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildBookCard(book),
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

  Widget _buildCategoryTab(String category, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.changeCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 24, bottom: 12),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.primary,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    String title = book['title'] ?? 'Untitled';
    String author = book['author'] ?? 'Unknown Author';
    String category = book['category'] ?? 'General';
    // Cover color logic: random or fixed if not in DB. Assuming backend might send a hex or we pick one.
    // For now, using primary or random color based on title length or specific field.
    // If backend sends 'color' field (which we added in model), we use it. 
    // BUT color in Flutter is int or Color obj. JSON has string hex or name.
    // Let's assume blue for now or parse if available.
    Color coverColor = (book['color'] is Color) ? book['color'] : AppColors.primary; 

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
          // Book Cover
          Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              color: coverColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(
                Icons.menu_book,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Book Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey, size: 22),
            onPressed: () {
              Get.to(() => AddBookView(
                bookData: book,
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey, size: 22),
            onPressed: () {
              if (book['_id'] != null) {
                  controller.deleteBook(book['_id']);
              }
            },
          ),
        ],
      ),
    );
  }
}
