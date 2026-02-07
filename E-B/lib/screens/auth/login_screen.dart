import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'register_view.dart';
import 'forgot_password_view.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Login",
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
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.menu_book_rounded,
                  size: 40, color: Colors.white),
            ),
            const SizedBox(height: 30),
            // Titles
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sign in to continue reading your favorite\nbooks.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 40),
            // Form
            CustomTextField(
              label: "Username",
              hint: "Enter your username",
              controller: controller.usernameController,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 24),
            Obx(() => CustomTextField(
                  label: "Password",
                  hint: "Enter your password",
                  controller: controller.passwordController,
                  isPassword: !controller.isPasswordVisible.value,
                  prefixIcon: Icons.lock,
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
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.to(() => const ForgotPasswordView()), // Link to Forgot Password
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => PrimaryButton(
                  text: "Login",
                  onPressed: controller.login,
                  isLoading: controller.isLoading.value,
                )),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don’t have an account? ",
                    style: TextStyle(color: AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => Get.to(() => const RegisterView()),
                  child: const Text(
                    "Register",
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
