import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'update_password_view.dart';
import 'login_screen.dart';
import '../../api/api_service.dart';
import '../User/user_main_view.dart';
import '../Admin/admin_main_view.dart';

class AuthController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Text Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullnameController = TextEditingController(); // Added
  final phoneController = TextEditingController();    // Added
  final genderController = TextEditingController();   // Added
  
  final newPasswordController = TextEditingController(); 
  final confirmPasswordController = TextEditingController(); 

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    isLoading.value = true;
    try {
      final response = await ApiService.login(
        usernameController.text,
        passwordController.text,
      );
      
      final token = response.data['token'];
      final role = response.data['role'];
      
      await ApiService.saveToken(token);
      
      Get.snackbar("Success", "Login successful", snackPosition: SnackPosition.BOTTOM);
      
      if (role == 'admin') {
        Get.offAllNamed('/admin');
      } else {
        Get.offAllNamed('/user');
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void register() async {
    isLoading.value = true;
    try {
      await ApiService.register(
        fullnameController.text,
        phoneController.text,
        genderController.text,
        usernameController.text,
        passwordController.text,
      );
      
      Get.snackbar("Success", "Account created! Please login.", snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Registration failed: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password Flow
  // Step 1: Verify Username
  void verifyUsername() async {
    final username = usernameController.text.trim();
    if (username.isEmpty) {
      Get.snackbar("Error", "Please enter username");
      return;
    }

    isLoading.value = true;
    try {
      await ApiService.verifyUsername(username);
      // If successful, navigate to UpdatePasswordView
      Get.to(() => const UpdatePasswordView());
    } catch (e) {
      // If it fails, show error
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          // Check if it's the specific "User not found" message from our new controller
          if (e.response?.data is Map && e.response?.data['msg'] == 'User not found') {
             Get.snackbar("Error", "Username not found in the database", 
                backgroundColor: Colors.red.withOpacity(0.1),
                colorText: Colors.red);
          } else {
             // If 404 but not our specific message, it means the API route itself is missing (Old Server)
             Get.snackbar("System Logic Error", "Backend server is outdated. Please RESTART the node server to apply changes.",
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.orange.withOpacity(0.2),
                colorText: Colors.orange[900]);
          }
        } else {
          Get.snackbar("Error", "Failed to verify. Status: ${e.response?.statusCode}",
              backgroundColor: Colors.red.withOpacity(0.1),
              colorText: Colors.red);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Step 2: Update Password
  void updatePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }
    
    isLoading.value = true;
    try {
      await ApiService.forgotPassword(
        usernameController.text.trim(),
        newPasswordController.text,
      );
      
      Get.snackbar("Success", "Password updated successfully!");
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Update failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      await ApiService.deleteToken();
      Get.offAllNamed('/login');
      Get.snackbar("Success", "Logged out successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Logout failed: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    fullnameController.dispose();
    phoneController.dispose();
    genderController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
