import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'admin_controller.dart';
import '../../api/api_service.dart';

class AddBookView extends StatefulWidget {
  final Map<String, dynamic>? bookData;

  const AddBookView({super.key, this.bookData});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

;
class _AddBookViewState extends State<AddBookView> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  String? selectedCategory

  PlatformFile? coverImageFile;
  PlatformFile? pdfFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.bookData?['title'] ?? '',
    );
    authorController = TextEditingController(
      text: widget.bookData?['author'] ?? '',
    );
    selectedCategory = widget.bookData?['category'];
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.bookData != null;

  Future<void> pickFile(bool isImage) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isImage ? FileType.image : FileType.custom,
      allowedExtensions: isImage ? null : ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (isImage) {
          coverImageFile = result.files.first;
        } else {
          pdfFile = result.files.first;
        }
      });
    }
  }

  Future<void> saveBook() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        selectedCategory == null) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    setState(() => isLoading = true);

    try {
      var formData = dio.FormData.fromMap({
        'title': titleController.text,
        'author': authorController.text,
        'category': selectedCategory,
        'description': 'Description placeholder', // Add field if needed
        'rating': 0,
      });

      if (coverImageFile != null) {
        // Handle web vs mobile
        if (coverImageFile!.bytes != null) {
          formData.files.add(
            MapEntry(
              'coverImage',
              dio.MultipartFile.fromBytes(
                coverImageFile!.bytes!,
                filename: coverImageFile!.name,
              ),
            ),
          );
        } else if (coverImageFile!.path != null) {
          formData.files.add(
            MapEntry(
              'coverImage',
              await dio.MultipartFile.fromFile(
                coverImageFile!.path!,
                filename: coverImageFile!.name,
              ),
            ),
          );
        }
      }

      if (pdfFile != null) {
        if (pdfFile!.bytes != null) {
          formData.files.add(
            MapEntry(
              'pdfUrl',
              dio.MultipartFile.fromBytes(
                pdfFile!.bytes!,
                filename: pdfFile!.name,
              ),
            ),
          );
        } else if (pdfFile!.path != null) {
          formData.files.add(
            MapEntry(
              'pdfUrl',
              await dio.MultipartFile.fromFile(
                pdfFile!.path!,
                filename: pdfFile!.name,
              ),
            ),
          );
        }
      }

      if (isEditing) {
        await ApiService.updateBook(widget.bookData!['_id'], formData);
      } else {
        await ApiService.addBook(formData);
      }

      Get.find<AdminController>().fetchBooks(); // Refresh list
      Get.back();
      Get.snackbar(
        'Success',
        'Book saved successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save book: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEditing ? 'Edit Book' : 'Add New Book',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book Title',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. The Psychology of Money',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Author Name',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                  hintText: 'e.g. Morgan Housel',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCategory,
                    hint: const Text('Select a category'),
                    items: ['Story', 'Love', 'Education', 'Islamic', 'History']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategory = v),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'PDF File',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildUploadBox(
                icon: Icons.picture_as_pdf,
                label: pdfFile != null ? pdfFile!.name : 'Upload PDF File',
                subtitle: 'Maximum file size 50MB',
                iconColor: const Color(0xFF4A5FE8),
                onTap: () => pickFile(false),
              ),
              const SizedBox(height: 20),

              const Text(
                'Cover Image',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildUploadBox(
                icon: Icons.image,
                label: coverImageFile != null
                    ? coverImageFile!.name
                    : 'Upload Cover Image',
                subtitle: 'JPG, PNG up to 5MB',
                iconColor: const Color(0xFF4A5FE8),
                onTap: () => pickFile(true),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEditing ? 'Save Changes' : 'Publish Book',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
