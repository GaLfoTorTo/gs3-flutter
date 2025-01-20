import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/widgets/alerts/alert_widget.dart';

class AppHelper {

  //FUNÇÃO DE VERIFICAÇÃO DE RETORNO DE API
  static void verifyResponse(response){
    //ESVAZIAR TIPO E MENSAGEM DE FEEDBACK
    String feedbackMessage = '';
    String feedbackType = '';
    //VERIFICAR SE RESPONSE NÃO SETA VAZIO
    if(response != null){
      //TENTAR ALERTAR 
      try {
        //RESGATAR STATUS E MENSAGEM
        feedbackType = response['status'] != 200 ? 'Error' : 'Success';
        feedbackMessage = response['message'];
      } catch (e) {
        //DEFINIR TIPO E MENSAGEM DE EERO
        feedbackType = 'Error';
        feedbackMessage = 'Ocorreu um erro inesperado!';
      } 
      //VERIFICAR SE MENSAGEM NÃO ESTA VAZIA
      if(feedbackMessage != '' && feedbackType != ''){
        //EXIBIR MENSAGEM DE ERRO
        AppHelper.alertMessage(feedbackMessage, type: feedbackType);
      }
    }
  }

  //FUNÇÃO PARA MOSTRAR ALERTA DE ERRO
  static void alertMessage(String message, {String? type}) {
    //EXIBIR SNACKBAR DO GET
    Get.snackbar(
      "",
      message,
      messageText: Container(
        decoration: BoxDecoration(
          color: type == 'Success' ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: type == 'Success' ? Colors.green : Colors.red,
      padding: EdgeInsets.only(bottom: 15),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
    );
  }
  
  //FUNÇÃO PARA MOSTRAR MODAL DE CARREGAMENTO
  static Map<String, dynamic> modalCarregamento(function) {
    //EXIBIR MODAL DE CARREGAMENTO
    Get.showOverlay(
      asyncFunction: () async {
        try {
          var response = await function();
          return {
            'status' : 200,
          };
        } catch(e) {
          //RETORNAR MENSAGEM DE ERRO
          return {
            'status': 400,
          };
        }
      },
      loadingWidget: Center(
        child: CircularProgressIndicator(color: Color(0xff0b1d2b)),
      ),
      opacityColor: Colors.black,
      opacity: 0.5,
    );
    return {
      'status' : 200,
    };
  }
  
  //FUNÇÃO PARA TRATAMENTO DE ERROS
  static Map<String, dynamic> tratamentoErros(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        //RETORNO PARA CONEXÃO CANCELADA
        return {
          'status': 504,
          'message':'Operação cancelada!'
        };
      case DioExceptionType.connectionTimeout || DioExceptionType.sendTimeout || DioExceptionType.receiveTimeout:
        //RETORNO PARA TEMPO EXPIRADO
        return {
          'status': 408,
          'message':'Conexão expirada!'
        };
      case DioExceptionType.badResponse:
        //RESGATAR  MENSAGEM DE ERRO
        var errorMessage = error.response?.data['message'];
        //RETORNO PARA TEMPO EXPIRADO
        return {
          'status': 400,
          'message': errorMessage
        };
      case DioExceptionType.unknown:
        //RETORNO PARA ERRO DESCONHECIDO
        return {
          'status': 500,
          'message':'Erro no servidor!'
        };
      default:
        //RETORNO PARA ERRO DESCONHECIDO
        return {
          'status': 504,
          'message':'Erro no servidor!'
        };
    }
  }
}