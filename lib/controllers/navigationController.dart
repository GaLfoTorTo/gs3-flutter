import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static NavigationController get instace => Get.find();
  //SCAFFOLD KEY
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //CONTROLADOR DE INDEX NAVIGATION BAR
  final Rx<int> index = 0.obs; 
  //FUNÇÃO DE ATUALIZAÇÃO DE INDEX
  void directIndex(int newIndex) {
    index.value = newIndex;
  }
  //FUNÇÃO DE INCREMENTAÇÃO DE INDEX
  void nextIndex() {
    index.value = index.value + 1;
  }
  //FUNÇÃO DE DECREMENTAÇÃO DE INDEX
  void backIndex() {
    index.value = index.value - 1;
  }
}