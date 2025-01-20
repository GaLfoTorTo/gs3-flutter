import 'package:get/get.dart';
import 'package:gs3_flutter/pages/formPage.dart';
import 'package:gs3_flutter/pages/homePage.dart';
import 'package:gs3_flutter/pages/loginPage.dart';
import 'package:gs3_flutter/pages/splashPage.dart';

class AppRoutes {
  static final routes = [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/login", page: () => const LoginPage(), transition: Transition.leftToRight),
      GetPage(name: "/", page: () => const HomePage(), transition: Transition.leftToRight),
      GetPage(name: "/novo", page: () => const FormPage(), transition: Transition.leftToRight),
      GetPage(name: "/editar", page: () => const FormPage(), transition: Transition.leftToRight),
  ];
}