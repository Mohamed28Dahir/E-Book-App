import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'book_reader_view.dart';

class BookDetailsView extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailsView({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Get.back(),
                    color: const Color(0xFF1E293B),
                  ),
                  const Text(
                    'Book Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Obx(() => IconButton(
                        icon: Icon(
                          controller.isFavorite(book)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 24,
                        ),
                        color: const Color(0xFF1E3A8A),
                        onPressed: () => controller.toggleFavorite(book),
                      )),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Book Cover
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Subtle Background Shadow/Glow
                        Container(
                          width: 220,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (book['color'] is Color ? book['color'] as Color : Colors.grey).withOpacity(0.3),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                        ),
                        // Actual Cover
                        Container(
                          width: 200,
                          height: 280,
                          decoration: BoxDecoration(
                            color: book['color'] ?? Colors.grey,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: (book['coverImage'] != null && book['coverImage'].toString().isNotEmpty)
                                ? (book['coverImage'].toString().startsWith('http')
                                    ? Image.network(
                                        book['coverImage'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _buildPlaceholder(),
                                      )
                                    : Image.asset(
                                        book['coverImage'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _buildPlaceholder(),
                                      ))
                                : _buildPlaceholder(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Book Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        book['title'] ?? 'Unknown Title',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Author
                    Text(
                      book['author'] ?? 'Unknown Author',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Rating Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                            const Text(
                              'RATE THIS BOOK',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                  final rating = (book['rating'] is num) ? (book['rating'] as num).toDouble() : 0.0;
                                final isFullStar = index < rating.floor();
                                return Icon(
                                  isFullStar ? Icons.star : Icons.star,
                                  color: isFullStar
                                      ? const Color(0xFFFACC15)
                                      : const Color(0xFFE2E8F0),
                                  size: 28,
                                );
                              }),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${book['rating'] ?? 0.0} (12,402 reviews)',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Read Book Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.addToHistory(book);
                          Get.to(() => BookReaderView(book: book));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Read Book',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        book['description'] ??
                            'Every book provides a chance to try another life you could have lived... Faced with the possibility of changing her life for a new one, Nora Seed finds herself faced with this decision.',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF475569),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tags
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildTag('Contemporary Fiction'),
                          _buildTag('Fantasy'),
                          _buildTag('${book['pages'] ?? 288} Pages'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
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
          Icon(Icons.book, size: 64, color: Colors.white.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            book['title'] ?? 'Book',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E3A8A),
        ),
      ),
    );
  }
}
