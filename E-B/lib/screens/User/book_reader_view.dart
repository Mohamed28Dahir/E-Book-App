import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class BookReaderView extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookReaderView({
    super.key,
    required this.book,
  });

  @override
  State<BookReaderView> createState() => _BookReaderViewState();
}

class _BookReaderViewState extends State<BookReaderView> {

  @override
  Widget build(BuildContext context) {
    final String? pdfUrl = widget.book['pdfUrl'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF1E3A8A)),
          label: const Text(
            'Library',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.book['title'] ?? 'Book Reader',
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pdfUrl != null && pdfUrl.isNotEmpty
          ? const PDF().cachedFromUrl(
              pdfUrl,
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text("Error: $error")),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'PDF file not found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
