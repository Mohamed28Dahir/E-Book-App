import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import '../widgets/favorite_book_card.dart';
import '../widgets/category_chip_widget.dart';

class FavoritesView extends GetView<UserController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.changeTab(0),
                    child: const Icon(Icons.arrow_back_ios,
                        size: 20, color: Color(0xFF1E293B)),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.more_horiz, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
            ),

            // Title and Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Favorites',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Obx(() => Text(
                          '${controller.favoriteBooks.length} books collected',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF94A3B8),
                          ),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => controller.updateFavoriteSearchQuery(value),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    hintText: 'Search in favorites',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Chips
            SizedBox(
              height: 45,
              child: Obx(() => ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CategoryChipWidget(
                        label: 'All',
                        isSelected:
                            controller.favoriteSelectedCategory.value == 'All',
                        onTap: () => controller.changeFavoriteCategory('All'),
                      ),
                      const SizedBox(width: 8),
                      for (var category in controller.categories)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChipWidget(
                            label: category,
                            isSelected:
                                controller.favoriteSelectedCategory.value ==
                                    category,
                            onTap: () =>
                                controller.changeFavoriteCategory(category),
                          ),
                        ),
                    ],
                  )),
            ),

            const SizedBox(height: 16),

            // Favorites List
            Expanded(
              child: Obx(() {
                final books = controller.favoritesFilteredBooks;
                if (books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites found',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return FavoriteBookCard(book: books[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
