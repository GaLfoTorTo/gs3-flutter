import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash();
  }

  void splash() async{
      //DELAY DE 2 SEGUNDOS
      await Future.delayed(Duration(seconds: 2));
      //NAVEGAR DE VOLTA PARA HOME PAGE
      Get.offAllNamed('/login');
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.jpg'),
      ),
    );
  }
}