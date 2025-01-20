import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/api/api.dart';
import 'package:gs3_flutter/helper/appHelper.dart';
import 'package:gs3_flutter/models/usuarioModel.dart';

class FormController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static FormController get instance => Get.find();
  //MODULO RECEBIDO POR PARAMETRO
  final String modulo;
  //USUÁRIO LOGADO RECEBIDO COMO PARÂMETRO
  UsuarioModel usuario;
  //PERIFS
  List<String> options = [];
  //CONSTRUTOR PARA RECEBER USUÁRIOS E PERFIS
  FormController({
    required this.modulo,
    required this.usuario,
  });
  // CONTROLLERS DE DADOS BASICOS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController perfilController = TextEditingController();

  //VALIDAÇÃO DE CAMPOS
  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }

  Future<Map<String, dynamic>> sendForm(String modulo, id) async {
    //BUSCAR URL BASICA
    var url = '${AppApi.url}';
    var data;
    //TENTAR SALVAR USUÁRIO
    try {
      //INSTANCIAR DIO
      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      //VERIFICAR MODULO
      if(modulo == 'perfis'){
        //CONCATENAR URL PARA PERFIL
        url = url + AppApi.salvarPerfil;
      }else{
        //CONCATENAR URL PARA USUARIOS
        url = url + AppApi.salvarUsuario;
      }
      //ENCODAR DADOS
      data = jsonEncode({
        'id' : id,
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'perfil' : perfilController.text
      });
      //INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${usuario.token}'
          },
        ),
        data: data,
      );    
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RESGATAR MENSAGEM DE SUCESSO
        String message = response.data['message'];
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
          'status': 400,
          'message': message,
        };
      }
    } on DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
  
  Future<Map<String, dynamic>> editar(String modulo, String id) async {
    //BUSCAR URL BASICA
    var url = '${AppApi.url}${modulo == 'perfis' ? AppApi.editarPerfil : AppApi.editarUsuario}$id';
    //ALTERAR MODULO
    String formType = modulo == 'perfis' ? 'perfil' : 'usuario';
    //TENTAR SALVAR USUÁRIO
    try {
      //INSTANCIAR DIO
      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      // INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${usuario.token}'
          },
        ),
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        Map<String, dynamic> data = response.data[formType];
        //RESGATAR VALORES DOS CAMPOS
        nameController.text = data['name'] != null ? data['name'] : '';
        emailController.text = data['email'] != null ? data['email'] : '';
        perfilController.text = data['perfil'] != null ? data['perfil'] : '';
        //VERIFICAR SE PERFIS FORAM RECEBIDOS
        if(response.data['perfis'] != null){
          //LOOP NOS PERFIS RECEBIDOS
          for(var i = 0; i < response.data['perfis'].length; i++){
            //RESGATAR PERFIS
            options.add(response.data['perfis'][i]['perfil']);
          }
        }
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
          'message': '',
        };
      } else {
        //RESGATAR MENSAGEM DE ERRO
        String message = response.data['message'];
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 400,
          'message': message,
        };
      }
    } on DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
}