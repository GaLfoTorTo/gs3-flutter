import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/api/api.dart';
import 'package:gs3_flutter/controllers/homeController.dart';
import 'package:gs3_flutter/helper/appHelper.dart';
import 'package:gs3_flutter/models/usuarioModel.dart';

class AuthController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static AuthController get instance => Get.find();

  //VALIDAÇÃO DE CAMPOS
  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }
  
  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>login(String user, String password) async {
    //BUSCAR URL BASICA
    var url = '${AppApi.url}login';
    //TENTAR SALVAR USUÁRIO
    try {
      //INSTANCIAR DIO
      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      // CRIAR OBJETO JSON
      var data = jsonEncode({'user': user, 'password': password});
      // INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: data,
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RESGATAR MENSAGEM DE SUCESSO
        String message = response.data['message'];
        //RESGATAR DADOS DO USUARIO LOGADO
        UsuarioModel usuario = UsuarioModel.fromMap(response.data['usuario']);
        //INICIALIZAR CONTROLLER HOMEPAGE
        Get.put(
          HomeController(usuario: usuario),
          permanent: true,
        );
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
          'message': message,
        };
      } else {
        //RESGATAR MENSAGEM DE ERRO
        String message = response.data['message'];
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 401,
          'message': message,
        };
      }
    } on DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
}