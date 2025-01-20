import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/controllers/authController.dart';
import 'package:gs3_flutter/helper/appHelper.dart';
import 'package:gs3_flutter/widgets/buttonTextWidget.dart';
import 'package:gs3_flutter/widgets/inputTextWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //CHAVE DO FORMULARIO
  final formKey = GlobalKey<FormState>();
  //INICIALIZAR CONTROLLDER DE AUTENTICAÇÃO
  final controller = AuthController.instance;
  //CONTROLLERS DE CAMPOS DO FORMULARIO
  final TextEditingController userController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');
  //VARIAVEL DE MENSAGEM DE ERRO
  String? feedbackMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //ENVIAR INFORMAÇÕES DE LOGIN
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //EFETUAR LOGIN
      AppHelper.modalCarregamento(login);
    }
  }

  // FUNÇÃO PARA EFETUAR LOGIN
  Future<void> login() async {
    setState(() {
      feedbackMessage = '';
    });
    //TENTAR EFETUAR LOGIN
    var response = controller.login(
      userController.text,
      passwordController.text,
    );
    //TIPO DE MENSAGEM
    String type = 'Error';
    //AGUARDAR O RESULTADO DO FUTURE
    try {
      var data = await response;
      //DEFINIR TIPO E MENSAGEM DE ERRO
      setState(() {
        type = data['status'] != 200 ? 'Error' : 'Success';
        feedbackMessage = data['message'];
      });
      //VERIFICAR SE OPERAÇÃO FOI BEM SUCEDIDA
      if (data['status'] == 200) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      feedbackMessage = 'Ocorreu um erro inesperado!';
    } 
    //EXIBIR MENSAGEM DE ERRO
    AppHelper.alertMessage(feedbackMessage!, type: type);
  }
    
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DA TELA
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: dimensions.height / 3 - 10,
                  child: Image.asset('assets/logo.jpg',
                    width: 100,
                    height: 100,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: dimensions.height / 3 - 20,
                  decoration: BoxDecoration(
                    color: Color(0xff0b1d2b),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withValues(alpha: 0.4),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(1,5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InputTextWidget(
                            name: 'user', 
                            hint: 'Email',
                            sufixIcon: Icons.email,
                            textController: userController, 
                            controller: controller,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InputTextWidget(
                            name: 'password', 
                            hint: 'Password', 
                            sufixIcon: Icons.visibility_off,
                            textController: passwordController, 
                            controller: controller,
                            type: TextInputType.visiblePassword,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ButtonTextWidget(
                    text: "Entrar",
                    textColor: Colors.white,
                    backgroundColor: Color(0xff0b1d2b),
                    width: double.infinity,
                    action: submitForm,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
  
  @override
  void dispose() {
    //DISPOSE DOS CONTROLLERS
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}