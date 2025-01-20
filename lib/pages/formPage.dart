import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/controllers/formController.dart';
import 'package:gs3_flutter/controllers/homeController.dart';
import 'package:gs3_flutter/helper/appHelper.dart';
import 'package:gs3_flutter/models/usuarioModel.dart';
import 'package:gs3_flutter/widgets/buttonTextWidget.dart';
import 'package:gs3_flutter/widgets/headerWidget.dart';
import 'package:gs3_flutter/widgets/inputTextWidget.dart';
import 'package:gs3_flutter/widgets/selectWidget.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  //RESGATAR ID DO REGISTRO
  final String? id = Get.parameters['id'];
  //RESGATAR MODULO
  final String modulo = Get.parameters['modulo']!;
  //RESGATAR AÇÃO DO FORMULÁRIO
  final String? formAction = Get.parameters['formAction'];
  //RESGATAR CONTROLLER DE FORM PAGE INICIALIZADO 
  final controller = FormController.instance;
  //CHAVE DO FORMULARIO
  final formKey = GlobalKey<FormState>();
  // Todas as variáveis permanecem iguais
  late Future<Map<String, dynamic>> futureData;
  //VARIAVEL DE MENSAGEM DE ERRO
  String feedbackMessage = '';
  //DEFINIR TIPO DE MENSAGEM DE RETORNO
  String feedbackType = '';
  //VARIAVEL DE DESCRIÇÃO DO FORMULÁRIO
  String? descricao = '';
  //VARIAVEL DE TIPO DE REGISTRO
  String? tipo = 'Usuário';
  //VARIAVEL DE DADOS DO REGISTRO
  Map<String, dynamic>? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BUSCAR REGISTRO
    futureData = buscarDados();
    //DEFINIR MENSAGEMS E TIPOS PARA CADA MODULO
    if(modulo == 'usuarios'){
      tipo = 'Usuário';
      formAction == 'Novo' 
        ? descricao = "Informe-nos os dados de Nome, Email e Senha para efetuar a criação do novo Usuário."
        : descricao = "Altere os dados de Nome, Email e Senha para efetuar a Edição do Usuário.";
    }else{
      tipo = 'Perfil';
      formAction == 'Novo'
        ? descricao = "Informe-nos o Nome do novo perfil a ser Criado."
        : descricao = "Altere o Nome do Perfil. Essa ação sera refletida para todos os usuarios que contem o mesmo perfil atribuido.";
    }
  }

  //SELECIONAR ARQUETIPO
  void selectPerfil(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      controller.perfilController.text = value;
    });
  }

  //RECARREGAR A PAGINA
  Future<void> recarregarPagina() async {
    //BUSCAR DADOS
    AppHelper.modalCarregamento(buscarDados);
  }

  //FUNÇÃO DE BUSCA DE DADOS DO REGISTRO PARA EDIÇÃO
  Future<Map<String, dynamic>> buscarDados() async{
    //VERIFICAR SE AÇÃO É UMA EDIÇÃO
    if(formAction == 'Editar'){
      //DELAY DE 2 SEGUNDOS
      await Future.delayed(Duration(seconds: 2));
      //BUSCAR DADOS PARA FORMULÁRIO
      var response = await controller.editar(modulo, id!);
      //MENSAGEM DE FEEDBACK
      AppHelper.verifyResponse(response);
      //RETORNAR RESPOSTA ( PARA EDIÇÃO )
      return response;
    }
    //RETORNAR MAPA VAZIO ( PARA NOVO )
    return {};
  }

  //FUNÇÃO PARA EFETUAR SALVAR INFORMAÇÕES
  Future<Map<String, dynamic>> salvar() async {
    //ENVIAR DADOS DO FORMULÁRIO
    var response = await controller.sendForm(modulo, id);
    //MENSAGEM DE FEEDBACK
    AppHelper.verifyResponse(response);
    //RETORNAR MAPA VAZIO ( PARA NOVO )
    return {};
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm() async{
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //ENVIAR FORMULÁRIO
      AppHelper.modalCarregamento(salvar);
      //DELAY DE 2 SEGUNDOS
      await Future.delayed(Duration(seconds: 1));
      //VERIFICAR SE OPERAÇÃO FOI BEM SUCEDIDA
      if(feedbackType == 'Success') {
        //INICIALIZAR CONTROLLER HOMEPAGE
        Get.put(
          HomeController(usuario: controller.usuario),
          permanent: true,
        );
        //NAVEGAR DE VOLTA PARA HOME PAGE
        Get.offAllNamed('/home');
      }
    }
  }

  formFiled(inputs){
    //USUÁRIO LOGADO RECEBIDO COMO PARÂMETRO
    UsuarioModel usuario = controller.usuario;
    //EXIBIR FOTO NO FORMULÁRIO
    String foto = id == 1 
                  ? "assets/logo.jpg" 
                  : "assets/user.png";
    //VERIFICAR MODULO
    if (modulo == 'usuarios'){
      return [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(foto),
              fit: BoxFit.cover,
            ),
          ),
        ),
        for (var input in inputs)
          InputTextWidget(
            name: input['name'],
            label: input['label'],
            prefixIcon: input['prefixIcon'],
            sufixIcon: input['sufixIcon'],
            textController: input['controller'],
            controller: controller,
            validator: input['validator'],
            type: input['type'],
          ),
        if(usuario.perfil != null && usuario.perfil!.id == 1)
          SelectWidget(
            label: 'Perfil', 
            options: controller.options, 
            onChanged: selectPerfil,
            selected: controller.perfilController.text,
          ),
      ];
    }else{
      return [
        InputTextWidget(
          name: 'perfil',
          label: 'perfil',
          prefixIcon: Icons.person,
          textController: controller.perfilController,
          controller: controller,
          type: TextInputType.text,
        )
      ];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name':'name',
        'label': 'Nome',
        'prefixIcon' : Icons.person_2_rounded,
        'controller': controller.nameController,
        'type': TextInputType.text
      },
      {
        'name':'email',
        'label': 'Email',
        'prefixIcon' : Icons.email,
        'controller': controller.emailController,
        'type': TextInputType.text
      },
      {
        'name':'password',
        'label': 'Senha',
        'prefixIcon' : Icons.lock,
        'sufixIcon' : Icons.visibility_off,
        'controller': controller.passwordController,
        'type': TextInputType.visiblePassword,
        'validator' : (){}
      },
    ];
    //RESGATAR DIMENSÕES DA TELA
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: HeaderWidget(
        title: '$formAction ${modulo == 'usuarios' ? 'Usuário' : 'Perfil'}',
        leftAction: Get.back,
      ),
      body: RefreshIndicator(
        onRefresh: recarregarPagina,
        child: SafeArea(
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              FutureBuilder(
                future: futureData,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //EXIBIÇÃO DE CARREGAMENTO DE HOME PAGE
                    return Center(
                      child: CircularProgressIndicator(color: Color(0xff0b1d2b)),
                    );
                  } else {
                    //VERIFICAR DADOS RECEBIDOS DA REQUISIÇÃO
                    if (snapshot.hasError) {
                      //ESPERAR CONSTRUÇÃO DO WIDGET PARA DISPARAR A MENSAGEM E ERRO
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        //EXIBIR MENSAGEM DE ERRO
                        AppHelper.alertMessage('Houve um erro ao buscar os usuários e perfis. Tente novamente');
                      });
                    }
                    return Container(
                      height: dimensions.height - 100,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Formulário de Cadastro",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        descricao!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12.withAlpha(25),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(1, 5),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: formFiled(inputs),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 60,
                            margin: EdgeInsets.all(5),
                            child: ButtonTextWidget(
                              text: "Salvar",
                              textColor: Colors.white,
                              icon: Icons.save,
                              backgroundColor: Color(0xff0b1d2b),
                              width: double.infinity,
                              action: submitForm,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}