import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_service.dart';

class AdminController extends GetxController {
  var selectedIndex = 0.obs; // Bottom nav index
  var selectedCategory = 'All'.obs; // Selected book category (default to 'All')
  var selectedUserFilter = 'All Users'.obs; // Selected user filter
  var isLoading = false.obs;

  var allBooks = <Map<String, dynamic>>[].obs;
  var allUsers = <Map<String, dynamic>>[].obs;

  var totalUsers = '0'.obs;
  var totalBooks = '0'.obs;
  var totalReads = '0'.obs;
  var newSubs = '0'.obs;

  var adminName = 'Admin'.obs;
  var adminUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
    fetchUsers();
    fetchStats();
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      final response = await ApiService.getProfile();
      final data = response.data;
      if (data != null) {
        if (data['fullname'] != null) adminName.value = data['fullname'];
        if (data['username'] != null) adminUsername.value = data['username'];
      }
    } catch (e) {
      print('Failed to fetch admin profile: $e');
    }
  }

  void fetchStats() async {
      try {
          final response = await ApiService.getDashboardStats();
          final data = response.data;
          totalUsers.value = data['totalUsers'].toString();
          totalBooks.value = data['totalBooks'].toString();
          totalReads.value = data['totalReads'].toString();
          newSubs.value = data['newSubs'].toString();
      } catch (e) {
          print('Failed to fetch stats: $e');
      }
  }

  void fetchBooks() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getBooks();
      // Assume API returns List<dynamic>
      List<dynamic> data = response.data;
      // Map correctly to local structure if necessary or adjust View
      // Backend returns: _id, title, author, category, color, etc.
      // Frontend view expects: title, author, category, color
      allBooks.value = data.map((e) {
        var map = Map<String, dynamic>.from(e);
        // Normalize Color
        if (map['color'] is String) {
          map['color'] = _parseColor(map['color']);
        } else if (map['color'] == null) {
          map['color'] = const Color(0xFF2D6A4F);
        }
        // Normalize Image
        if (map['coverImage'] != null && map['coverImage'].toString().isNotEmpty) {
          map['coverImage'] = ApiService.getFileUrl(map['coverImage']);
        }
        // Normalize PDF
        if (map['pdfUrl'] != null && map['pdfUrl'].toString().isNotEmpty) {
          map['pdfUrl'] = ApiService.getFileUrl(map['pdfUrl']);
        }
        // Normalize Rating to double
        if (map['rating'] != null) {
          map['rating'] = (map['rating'] as num).toDouble();
        } else {
          map['rating'] = 0.0;
        }
        return map;
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch books: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void fetchUsers() async {
      try {
          final response = await ApiService.getUsers();
          List<dynamic> data = response.data;
          allUsers.value = data.map((e) => Map<String, dynamic>.from(e)).toList();
      } catch (e) {
           Get.snackbar('Error', 'Failed to fetch users: $e');
      }
  }

  // Get filtered books based on selected category
  List<Map<String, dynamic>> get filteredBooks {
    if (selectedCategory.value == 'All') {
      return allBooks;
    }
    return allBooks.where((book) => book['category'] == selectedCategory.value).toList();
  }

  // Get top 5 books sorted by rating
  List<Map<String, dynamic>> get topWeeklyBooks {
    var sorted = List<Map<String, dynamic>>.from(allBooks);
    sorted.sort((a, b) {
      double ra = (a['rating'] is num) ? (a['rating'] as num).toDouble() : 0.0;
      double rb = (b['rating'] is num) ? (b['rating'] as num).toDouble() : 0.0;
      return rb.compareTo(ra);
    });
    return sorted.take(5).toList();
  }

  // Get the single top performing book
  Map<String, dynamic>? get topPerformingBook {
    var books = topWeeklyBooks;
    return books.isNotEmpty ? books.first : null;
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // Get filtered users based on selected filter
  List<Map<String, dynamic>> get filteredUsers {
    if (selectedUserFilter.value == 'All Users') {
      return allUsers;
    }
    // Simple mock filter for now, or implement actual date logic
    return allUsers; 
  }

  void changeUserFilter(String filter) {
    selectedUserFilter.value = filter;
  }

  Future<void> deleteBook(String id) async {
       try {
           await ApiService.deleteBook(id);
           fetchBooks();
           Get.snackbar('Success', 'Book deleted');
       } catch (e) {
           Get.snackbar('Error', 'Failed to delete book');
       }
  }

  Future<void> deleteUser(String id) async {
       try {
           await ApiService.deleteUser(id);
           fetchUsers();
           Get.snackbar('Success', 'User deleted');
       } catch (e) {
           Get.snackbar('Error', 'Failed to delete user');
       }
  }
  Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF2D6A4F);
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return const Color(0xFF2D6A4F);
    }
  }
}
