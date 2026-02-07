import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary), // Blue back button based on design
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Back", // Design says "Back" next to arrow, but title is "Reset Password" in body? No, top left says "Back".
          // Actually design has standard back arrow and text "Back".
          // And a large Header "Reset Password".
          // Let's hide the default title and use the body for the header.
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Reset Password",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 12),
            const Text(
              "Enter your username to find your account and start the recovery process.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              label: "Username",
              hint: "Enter your username",
              controller: controller.usernameController, // Reusing username controller or create new one?
              // Ideally should use a separate one or clear it. Let's assume reusing is fine for now, or clearer to have focused logic.
              // I'll reuse it but in a real app might want separate variables.
            ),
             const SizedBox(height: 32),
            Obx(() => PrimaryButton(
                  text: "Verify Username",
                  onPressed: controller.verifyUsername,
                  isLoading: controller.isLoading.value,
                )),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.lock, size: 16, color: AppColors.textSecondary),
                   const SizedBox(width: 8),
                   const Text("Secure account verification", style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
