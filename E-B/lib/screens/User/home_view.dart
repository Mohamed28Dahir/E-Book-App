import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import '../widgets/book_card_widget.dart';
import '../widgets/category_chip_widget.dart';

class HomeView extends GetView<UserController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4D6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFFF8C42),
                        size: 24,
                      ),
                    ),
                    // Title
                    const Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    // Search Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Color(0xFF1E293B),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top 5 Most Read Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Top 5 Most Read (Weekly)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.top5Books.length,
                      itemBuilder: (context, index) {
                        final book = controller.top5Books[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: BookCardWidget(
                            title: book['title'],
                            author: book['author'],
                            rating: book['rating'],
                            backgroundColor: book['color'],
                            coverImage: book['coverImage'],
                            isCarousel: true,
                            bookData: book,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Category Filter Chips
            SliverToBoxAdapter(
              child: SizedBox(
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
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // All Books Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Books',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.tune,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // All Books Grid
            Obx(() {
              final books = controller.filteredBooks;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
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
                    childCount: books.length,
                  ),
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
