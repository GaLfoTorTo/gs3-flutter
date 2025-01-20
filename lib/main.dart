import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/controllers/authController.dart';
import 'package:gs3_flutter/controllers/navigationController.dart';
import 'package:gs3_flutter/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //INICIALIZAR CONTROLLER DE AUTENTICAÇÃO
    Get.put(AuthController());
    //INICIALIZAR CONTROLLER DE NAVEGAÇÃO
    Get.put(NavigationController(), permanent: true);
    
    return GetMaterialApp(
      title: 'GS3 Flutter',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff0b1d2b),
      ),
      initialRoute: '/splash',
      getPages: AppRoutes.routes,
    );
  }
}