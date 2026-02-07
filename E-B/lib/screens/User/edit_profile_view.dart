import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import '../widgets/primary_button.dart';

class EditProfileView extends GetView<UserController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: controller.userName.value);
    final TextEditingController usernameController =
        TextEditingController(text: controller.userUsername.value);

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
                        'Edit Profile',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image/Avatar
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Obx(() => Text(
                                    controller.userName.value.isNotEmpty 
                                        ? controller.userName.value.substring(0, 1).toUpperCase() 
                                        : 'U',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E3A8A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    
                    // Username Input
                    const Text(
                      'USERNAME',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your username',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name Input
                    const Text(
                      'FULL NAME',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Save Button
                    PrimaryButton(
                      text: 'Save Changes',
                      onPressed: () async {
                        // Update Profile (Name)
                        if (nameController.text != controller.userName.value) {
                             await controller.updateUserProfile(nameController.text, '', '');
                        }
                        
                        // Update Username
                        if (usernameController.text != controller.userUsername.value) {
                             await controller.updateUsernameApi(usernameController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

