import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../User/book_details_view.dart';
import '../User/user_controller.dart';
import '../User/book_reader_view.dart';

class FavoriteBookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const FavoriteBookCard({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return GestureDetector(
      onTap: () => Get.to(() => BookDetailsView(book: book)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                color: book['color'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: book['coverImage'] != null
                    ? Image.asset(
                        book['coverImage'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            const SizedBox(width: 16),
            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          book['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Obx(() => IconButton(
                            icon: Icon(
                              controller.isFavorite(book)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color(0xFF1E3A8A),
                            ),
                            onPressed: () => controller.toggleFavorite(book),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )),
                    ],
                  ),
                  Text(
                    book['author'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        book['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(1.2k reviews)', // Placeholder for count as per design
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Spacer(),
                      // Read Button
                      ElevatedButton(
                        onPressed: () {
                          controller.addToHistory(book);
                          Get.to(() => BookReaderView(book: book));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE2E8F0),
                          foregroundColor: const Color(0xFF1E3A8A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Read',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book,
            size: 32,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          const Text(
            'No Image',
            style: TextStyle(
              fontSize: 8,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
