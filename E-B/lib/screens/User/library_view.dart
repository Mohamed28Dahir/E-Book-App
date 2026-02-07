import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import '../widgets/book_card_widget.dart';
import '../widgets/category_chip_widget.dart';

class LibraryView extends GetView<UserController> {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with menu and title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Menu Icon
                  IconButton(
                    icon: const Icon(Icons.menu, size: 28),
                    onPressed: () {
                      // TODO: Open drawer/menu
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Library Explorer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for menu icon
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              
                child: TextField(
                  onChanged: (value) => controller.updateSearchQuery(value),
                  decoration: const InputDecoration(
                    hintText: 'Search books, authors...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Filter Chips
            SizedBox(
              height: 45,
              child: Obx(() => ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CategoryChipWidget(
                        label: 'All',
                        isSelected: controller.selectedCategory.value == 'All',
                        onTap: () => controller.changeCategory('All'),
                      ),
                      const SizedBox(width: 8),
                      ...controller.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChipWidget(
                            label: category,
                            isSelected:
                                controller.selectedCategory.value == category,
                            onTap: () => controller.changeCategory(category),
                          ),
                        );
                      }),
                    ],
                  )),
            ),

            const SizedBox(height: 16),

            // Books Grid
            Expanded(
              child: Obx(() {
                final books = controller.libraryFilteredBooks;
                
                if (books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No books found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search or category',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return BookCardWidget(
                        title: book['title'],
                        author: book['author'],
                        rating: book['rating'],
                        backgroundColor: book['color'],
                        coverImage: book['coverImage'],
                        isCarousel: false,
                        bookData: book,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
