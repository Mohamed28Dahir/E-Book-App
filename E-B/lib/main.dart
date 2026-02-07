import 'package:flutter/material.dart';
import 'package:e_book_app/api/api_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/utils/app_colors.dart';
import 'screens/auth/auth_binding.dart';
import 'screens/auth/login_screen.dart';
import 'screens/Admin/admin_binding.dart';
import 'screens/Admin/admin_main_view.dart';
import 'screens/User/user_binding.dart';
import 'screens/User/user_main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  runApp(const EBookApp());
}

class EBookApp extends StatelessWidget {
  const EBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-Book Library',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.primary,
        ),
      ),
      initialBinding: AuthBinding(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/admin',
          page: () => const AdminMainView(),
          binding: AdminBinding(),
        ),
        GetPage(
          name: '/user',
          page: () => const UserMainView(),
          binding: UserBinding(),
        ),
      ],
      home: const LoginScreen(),
    );
  }
}
