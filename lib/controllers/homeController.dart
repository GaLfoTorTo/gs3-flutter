import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/api/api.dart';
import 'package:gs3_flutter/helper/appHelper.dart';
import 'package:gs3_flutter/models/usuarioModel.dart';

class HomeController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static HomeController get instance => Get.find();
  //USUÁRIO LOGADO RECEBIDO COMO PARÂMETRO
  UsuarioModel usuario;
  //CONSTRUTOR PARA RECEBER USUÁRIOS E PERFIS
  HomeController({
    required this.usuario,
  });
  
  //FUNÇÃO DE BUSCA PROXIMA PAGINA
  Future<Map<String, dynamic>> fetchHome() async {
    //URL DE BUSCA
    var url = '${AppApi.url}home';
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
        //RESGATAR USUARIOS PARA LISTAGEM
        var usuarios = response.data['usuarios'];
        //RESGATAR PERFIS PARA LISTAGEM
        var perfis = response.data['perfis'];
        //ENVIAR PARA PAGINA
        return {
          'status': 200,
          'usuarios': usuarios,
          'perfis': perfis
        };
      } else {
        //RESGATAR MENSAGEM DE ERRO
        String message = response.data['message'] ?? 'Erro desconhecido';
        //RETORNAR MENSAGEM DE ERRO
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
  
  //FUNÇÃO DE BUSCA PROXIMA PAGINA
  Future<Map<String, dynamic>> deletar(modulo, id) async {
    //URL DE BUSCA
    var url = '${AppApi.url}$modulo/deletar/$id';
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
        //RESGATAR MENSAGEM DE ERRO
        String message = response.data['message'] ?? 'Erro desconhecido';
        //RETORNAR MENSAGEM DE ERRO
        return {
          'status': 200,
          'message': message,
        };
      } else {
        //RESGATAR MENSAGEM DE ERRO
        String message = response.data['message'] ?? 'Erro desconhecido';
        //RETORNAR MENSAGEM DE ERRO
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