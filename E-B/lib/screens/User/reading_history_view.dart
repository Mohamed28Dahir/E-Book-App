import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import '../widgets/favorite_book_card.dart';

class ReadingHistoryView extends GetView<UserController> {
  const ReadingHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Get.back(),
                    color: const Color(0xFF1E293B),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Reading History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                final history = controller.readingHistory;
                if (history.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No history available',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return FavoriteBookCard(book: history[index]);
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
