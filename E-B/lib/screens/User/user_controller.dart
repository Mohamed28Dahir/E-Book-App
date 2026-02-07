import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_service.dart';

class UserController extends GetxController {
  var selectedIndex = 0.obs; // Bottom nav index
  var selectedCategory = 'All'.obs; // Selected book category
  var searchQuery = ''.obs; // Search query for library

  // Favorites state
  var favoriteBooks = <Map<String, dynamic>>[].obs;
  var favoriteSearchQuery = ''.obs;
  var favoriteSelectedCategory = 'All'.obs;

  // Profile and History state
  // Profile and History state
  var userName = 'Mohamed Dahir'.obs; // This is actually Full Name
  var userUsername = ''.obs; // This is the unique username
  var readingHistory = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;
  
  // Book data
  final List<Map<String, dynamic>> top5Books = []; // Keep empty or fill from allBooks logic later
  // Main books list - fetched from API
  var allBooks = <Map<String, dynamic>>[].obs;
  

  void fetchUserProfile() async {
    try {
      final response = await ApiService.getProfile();
      final data = response.data;
      if (data != null) {
          if (data['fullname'] != null) userName.value = data['fullname'];
          if (data['username'] != null) userUsername.value = data['username'];
      }
    } catch (e) {
      print('Failed to fetch profile: $e');
    }
  }

  void fetchBooks() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getBooks();
      List<dynamic> data = response.data;
      
      allBooks.value = data.map((e) => _normalizeBook(e)).toList();
      
      // Populate Top 5 (Take first 5 or sort by rating if available)
      if (allBooks.isNotEmpty) {
        var sorted = List<Map<String, dynamic>>.from(allBooks);
        sorted.sort((a, b) {
           double ra = (a['rating'] is num) ? (a['rating'] as num).toDouble() : 0.0;
           double rb = (b['rating'] is num) ? (b['rating'] as num).toDouble() : 0.0;
           return rb.compareTo(ra); // Descending
        });
        top5Books.assignAll(sorted.take(5).toList());
      } else {
        top5Books.clear();
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch books: $e');
    } finally {
      isLoading.value = false;
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

  Future<void> updateUserProfile(String name, String phone, String gender) async {
      try {
          final response = await ApiService.updateProfile({
              'fullname': name,
              'phone': phone,
              'gender': gender // Optional if UI has it
          });
          userName.value = response.data['fullname'];
          Get.back();
          Get.snackbar('Success', 'Profile updated successfully');
      } catch (e) {
          Get.snackbar('Error', 'Failed to update profile');
      }
  }



  // Categories
  final List<String> categories = [
    'Story',
    'Love',
    'Education',
    'Islamic',
  ];

  // Get filtered books based on selected category
  List<Map<String, dynamic>> get filteredBooks {
    if (selectedCategory.value == 'All') {
      return allBooks;
    }
    return allBooks
        .where((book) => book['category'] == selectedCategory.value)
        .toList();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Get filtered books for library (based on category and search)
  List<Map<String, dynamic>> get libraryFilteredBooks {
    var books = allBooks.toList();
    
    // Filter by category
    if (selectedCategory.value != 'All') {
      books = books.where((book) => book['category'] == selectedCategory.value).toList();
    }
    
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      books = books.where((book) {
        final title = book['title'].toString().toLowerCase();
        final author = book['author'].toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }
    
    return books;
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch data from API
    fetchUserProfile();
    fetchBooks();
    fetchFavorites();
    fetchHistory();
  }

  void fetchFavorites() async {
    try {
      final response = await ApiService.getFavorites();
      List<dynamic> data = response.data;
      favoriteBooks.value = data.map((e) => _normalizeBook(e)).toList();
    } catch (e) {
      print('Failed to fetch favorites: $e');
    }
  }

  void fetchHistory() async {
    try {
      final response = await ApiService.getHistory();
      List<dynamic> data = response.data;
      // History response is [{book: {...}, readAt: ...}]
      // We need to extract the book object and normalize it
      readingHistory.value = data.map((e) {
          if (e['book'] != null) {
              return _normalizeBook(e['book']);
          }
          return <String, dynamic>{};
      }).where((map) => map.isNotEmpty).toList();
    } catch (e) {
      print('Failed to fetch history: $e');
    }
  }

  void updateUserName(String newName) {
    if (newName.isNotEmpty) {
      userName.value = newName;
    }
  }
  
  // Real update username API call
  Future<void> updateUsernameApi(String newUsername) async {
      try {
          final response = await ApiService.updateUsername(newUsername);
          // Assuming response has user object or we just trust the input on success
           if (response.data != null && response.data['user'] != null) {
               userUsername.value = response.data['user']['username'];
           }
          Get.snackbar('Success', 'Username updated successfully');
      } catch (e) {
          Get.snackbar('Error', 'Failed to update username: ${e.toString()}');
      }
  }

  void addToHistory(Map<String, dynamic> book) async {
    // Optimistic update
    if (!readingHistory.any((b) => b['_id'] == book['_id'])) {
      readingHistory.insert(0, book);
    }
    
    // API call
    if (book['_id'] != null) {
        try {
            await ApiService.addToHistory(book['_id']);
            // Optionally refetch to get exact server order/data
        } catch (e) {
            print('Failed to add to history: $e');
        }
    }
  }

  void toggleFavorite(Map<String, dynamic> book) async {
    bool isFav = isFavorite(book);
    String? id = book['_id'];
    
    if (id == null) return;

    if (isFav) {
      favoriteBooks.removeWhere((b) => b['_id'] == id);
      try {
          await ApiService.removeFavorite(id);
      } catch (e) {
          favoriteBooks.add(book); // Revert
          Get.snackbar('Error', 'Failed to remove favorite');
      }
    } else {
      favoriteBooks.add(book);
      try {
          await ApiService.addFavorite(id);
      } catch (e) {
          favoriteBooks.removeWhere((b) => b['_id'] == id); // Revert
          Get.snackbar('Error', 'Failed to add favorite');
      }
    }
  }

  bool isFavorite(Map<String, dynamic> book) {
    return favoriteBooks.any((b) => b['_id'] == book['_id']);
  }

  // Helper to normalize book data (duplicated from fetchBooks logic, extracted for reuse)
  Map<String, dynamic> _normalizeBook(dynamic e) {
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
  }

  void updateFavoriteSearchQuery(String query) {
    favoriteSearchQuery.value = query;
  }

  void changeFavoriteCategory(String category) {
    favoriteSelectedCategory.value = category;
  }

  List<Map<String, dynamic>> get favoritesFilteredBooks {
    var books = favoriteBooks.toList();

    // Filter by category
    if (favoriteSelectedCategory.value != 'All') {
      books = books
          .where((book) => book['category'] == favoriteSelectedCategory.value)
          .toList();
    }

    // Filter by search query
    if (favoriteSearchQuery.value.isNotEmpty) {
      books = books.where((book) {
        final title = book['title'].toString().toLowerCase();
        final author = book['author'].toString().toLowerCase();
        final query = favoriteSearchQuery.value.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }
    return books;
  }
}

