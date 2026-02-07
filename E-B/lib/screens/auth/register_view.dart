import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Register",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle, // Circle shape like design
              ),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF), // Light indigo
                      shape: BoxShape.circle),
                  child: const Icon(Icons.menu_book_rounded,
                      size: 40, color: AppColors.primary)),
            ),
            const SizedBox(height: 30),
            // Titles
            const Text(
              "Join the Library",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Join our library of thousands of eBooks",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 40),
            // Form
            CustomTextField(
              label: "Full Name",
              hint: "Enter your full name",
              controller: controller.fullnameController,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: "Phone",
              hint: "Enter your phone number",
              controller: controller.phoneController,
              prefixIcon: Icons.phone,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: "Gender",
              hint: "Male / Female",
              controller: controller.genderController,
              prefixIcon: Icons.people,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: "Username",
              hint: "Enter a unique username",
              controller: controller.usernameController,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 24),
            Obx(() => CustomTextField(
                  label: "Password",
                  hint: ".......",
                  controller: controller.passwordController,
                  isPassword: !controller.isPasswordVisible.value,
                  // Screenshot has NO prefix icon for password
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),
            const SizedBox(height: 40),
            Obx(() => PrimaryButton(
                  text: "Register",
                  onPressed: controller.register,
                  isLoading: controller.isLoading.value,
                )),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style: TextStyle(color: AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => Get.off(() => const LoginScreen()),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
