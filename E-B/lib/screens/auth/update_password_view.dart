import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

class UpdatePasswordView extends GetView<AuthController> {
  const UpdatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        // Design doesn't show "Back" text explicitly but inferred from previous screen style usually.
        // However, let's keep it clean.
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Reset Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
             const SizedBox(height: 30),
            const Text(
              "Create New Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
                children: [
                  TextSpan(text: "Hello, "),
                  TextSpan(text: "alex.reader@email.com", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  TextSpan(text: ". Please enter a strong new password for your account."),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => CustomTextField(
                  label: "New Password",
                  hint: "Enter new password",
                  controller: controller.newPasswordController,
                  isPassword: !controller.isPasswordVisible.value,
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
            const SizedBox(height: 24),
             Obx(() => CustomTextField(
                  label: "Confirm New Password",
                  hint: "Confirm new password",
                  controller: controller.confirmPasswordController,
                  isPassword: !controller.isPasswordVisible.value,
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
            const Text(
              "Password must be at least 8 characters long and include a mix of letters, numbers, and symbols.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 40),
            Obx(() => PrimaryButton(
                  text: "Update Password",
                  onPressed: controller.updatePassword,
                  isLoading: controller.isLoading.value,
                )),
             const SizedBox(height: 20),
             TextButton(
               onPressed: () => Get.offAll(() => const LoginScreen()),
               child: const Text("Cancel and return to login", style: TextStyle(color: AppColors.textSecondary)),
             )
          ],
        ),
      ),
    );
  }
}
