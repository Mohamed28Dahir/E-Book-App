import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../User/book_details_view.dart';

class BookCardWidget extends StatelessWidget {
  final String title;
  final String author;
  final double rating;
  final Color backgroundColor;
  final String? coverImage;
  final bool isCarousel;
  final VoidCallback? onTap;
  final Map<String, dynamic>? bookData;

  const BookCardWidget({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.backgroundColor,
    this.coverImage,
    this.isCarousel = false,
    this.onTap,
    this.bookData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (bookData != null) {
          Get.to(() => BookDetailsView(book: bookData!));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover
          Container(
            width: isCarousel ? 160 : double.infinity,
            height: isCarousel ? 220 : 200,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: coverImage != null
                  ? (coverImage!.startsWith('http') 
                      ? Image.network(
                          coverImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        )
                      : Image.asset(
                          coverImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        ))
                  : _buildPlaceholder(),
            ),
          ),
          const SizedBox(height: 8),
          // Book Title
          SizedBox(
            width: isCarousel ? 160 : double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Author and Rating
          SizedBox(
            width: isCarousel ? 160 : double.infinity,
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 14,
                  color: Color(0xFFFFA500),
                ),
                const SizedBox(width: 4),
                Text(
                  '$author • $rating',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

