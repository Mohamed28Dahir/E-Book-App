import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../../api/api_service.dart';
import 'admin_controller.dart';

class AddUserView extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const AddUserView({super.key, this.userData});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController fullnameController;
  late TextEditingController phoneController;
  String selectedRole = 'User';
  bool isPasswordVisible = false;
  bool isLoading = false;
  
  bool get isEditing => widget.userData != null;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.userData?['username'] ?? '');
    passwordController = TextEditingController(); // Don't pre-fill password usually, or let user reset it
    fullnameController = TextEditingController(text: widget.userData?['fullname'] ?? '');
    phoneController = TextEditingController(text: widget.userData?['phone'] ?? '');
    genderController = TextEditingController(text: widget.userData?['gender'] ?? '');
    
    if (widget.userData?['role'] != null) {
       // Capitalize first letter for UI if needed "user" -> "User"
       String r = widget.userData!['role'].toString();
       if (r.isNotEmpty) {
           selectedRole = r[0].toUpperCase() + r.substring(1);
           // Ensure it matches dropdown items
           if (!['User', 'Admin'].contains(selectedRole)) selectedRole = 'User';
       }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    fullnameController.dispose();
    phoneController.dispose();
    genderController.dispose();
    super.dispose();
  }
  
  void createUser() async {
      if(usernameController.text.isEmpty) {
           Get.snackbar('Error', 'Username is required');
           return;
      }
      if (!isEditing && passwordController.text.isEmpty) {
          Get.snackbar('Error', 'Password is required for new users');
          return;
      }
      
      setState(() => isLoading = true);
      try {
          Map<String, dynamic> data = {
              'fullname': fullnameController.text.isNotEmpty ? fullnameController.text : 'New User',
              'phone': phoneController.text.isNotEmpty ? phoneController.text : '0000000000',
              'gender': genderController.text.isNotEmpty ? genderController.text : 'Not Specified',
              'role': selectedRole.toLowerCase(),
          };
          
          if (!isEditing) {
             data['username'] = usernameController.text;
             data['password'] = passwordController.text;
             await ApiService.addUser(data);
          } else {
             // For update, we might not allow username change if backend restricts it, but we send if allowed.
             // Backend update logic handles fields provided.
             if (passwordController.text.isNotEmpty) {
                 data['password'] = passwordController.text;
             }
             await ApiService.updateUser(widget.userData!['_id'], data);
          }
          
          Get.find<AdminController>().fetchUsers(); // Refresh
          Get.back();
          Get.snackbar('Success', isEditing ? 'User updated' : 'User created', backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
          Get.snackbar('Error', 'Failed: $e', backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
          setState(() => isLoading = false);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add New User',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 32),
              
              // New Fields needed for Backend
              TextField(
                controller: fullnameController,
                 decoration: InputDecoration(
                  hintText: 'Full Name',
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
               TextField(
                controller: phoneController,
                 decoration: InputDecoration(
                  hintText: 'Phone',
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              
              // Username
              const Text('Username', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 8),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter username',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),

              // Password
              const Text('Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey[400]),
                    onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),

              // Role
              const Text('Role', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedRole,
                    items: ['User', 'Admin'].map((role) => DropdownMenuItem(child: Text(role), value: role)).toList(),
                    onChanged: (value) => setState(() => selectedRole = value!),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : createUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
