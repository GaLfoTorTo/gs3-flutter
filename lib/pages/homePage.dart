import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs3_flutter/controllers/formController.dart';
import 'package:gs3_flutter/controllers/homeController.dart';
import 'package:gs3_flutter/helper/appHelper.dart';
import 'package:gs3_flutter/models/perfilModel.dart';
import 'package:gs3_flutter/models/usuarioModel.dart';
import 'package:gs3_flutter/widgets/buttonTextWidget.dart';
import 'package:gs3_flutter/widgets/headerWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin  {
  //RESGATAR CONTROLLER DE HOME PAGE INICIALIZADO
  final controller = HomeController.instance;
  //CONTROLLER DE ABAS
  late final TabController tabController;
  //MODEL DO USUARIO
  late UsuarioModel usuario;
  //USUARIOS LISTAGEM
  List<UsuarioModel> usuarios = [];
  //USUARIOS PERFIS
  List<PerfilModel> perfis = [];
  //TITULO DO BOTÃO
  RxString buttonTitle = 'Novo Usuário'.obs;
  //MODULO ATUAL 
  String modulo = 'usuarios';
  //VARIAVEL DE MENSAGEM DE ERRO
  String feedbackMessage = '';
  //DEFINIR TIPO DE MENSAGEM DE RETORNO
  String feedbackType = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void navegateForm(String formAction, int? id){
    //VERIFICAR SE É UMA EDIÇÃO OU CRIAÇÃO
    if(formAction == 'Editar'){
      //IR PARA FORMULARIO NO FORMATO DE EDIÇÃO
      Get.toNamed('editar', parameters: {
        'modulo' : modulo,
        'formAction': 'Editar',
        'id' : '$id'
      });
    }else{
      //IR PARA FORMULARIO NO FORMATO DE NOVO
      Get.toNamed('novo', parameters: {
        'modulo' : modulo,
        'formAction': 'Novo',
      });
    }
    //INICIALIZAR CONTROLLER DO FORMULÁRIO
    Get.put(FormController(modulo: modulo, usuario: usuario));
  }

 Future<void> buscarDados() async{
    //DELAY DE 1 SEGUNDO
    await Future.delayed(Duration(seconds: 1));
    //BUSCAR DADOS PARA FORMULÁRIO
    controller.fetchHome();
  }

  //FUNÇÃO DE BUSCA DE DADOS DO REGISTRO PARA EDIÇÃO
  Future<Map<String, dynamic>> deletar(modulo, id) async{
    modulo = modulo == 'Usuario' ? 'usuarios' : 'perfis';
    //ENVIAR FORMULÁRIO
    Map<String, dynamic> feedback = AppHelper.modalCarregamento(controller.deletar(modulo, id));
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 1));
    //VERIFICAR SE OPERAÇÃO FOI BEM SUCEDIDA
    if(feedback.isNotEmpty) {
      //INICIALIZAR CONTROLLER HOMEPAGE
      Get.put(
        HomeController(usuario: controller.usuario),
        permanent: true,
      );
      //NAVEGAR DE VOLTA PARA HOME PAGE
      Get.offAllNamed('/home');
    }
    //RETORNAR MAPA VAZIO ( PARA NOVO )
    return {};
  }

  //FUNÇÃO DE RETORNO PARA HOME
  void showModalDeletar(BuildContext context, String modulo, String id) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Deletar $modulo',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Deseja deletar o $modulo?',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonTextWidget(
                    text: "Não",
                    width: 50,
                    height: 20,
                    action: () => Get.back(),
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  ),
                  ButtonTextWidget(
                    text: "Sim",
                    width: 50,
                    height: 20,
                    action: () => deletar(modulo, id),
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    //RESGATAR DIMENSÕES DA TELA
    var dimensions = MediaQuery.of(context).size;

    //EXIBIR FOTO NO FORMULÁRIO
    String foto = controller.usuario.id == 1 
                  ? "assets/logo.jpg" 
                  : "assets/user.png";

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: HeaderWidget(
        title: 'Home',
        rightAction: () => Get.offNamed('/login'),
      ),
      body: RefreshIndicator(
        onRefresh: buscarDados,
        child: SafeArea(
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: controller.fetchHome(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //EXIBIÇÃO DE CARREGAMENTO DE HOME PAGE
                    return Center(
                      child: CircularProgressIndicator(color: Color(0xff0b1d2b)),
                    );
                  } else {
                    //RESGATAR DADOS DO USUARIO LOGADO
                    usuario = controller.usuario;
                    //VERIFICAR DADOS RECEBIDOS DA REQUISIÇÃO
                    if (snapshot.hasError) {
                      //ESPERAR CONSTRUÇÃO DO WIDGET PARA DISPARAR A MENSAGEM E ERRO
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        //EXIBIR MENSAGEM DE ERRO
                        AppHelper.alertMessage('Houve um erro ao buscar os usuários e perfis. Tente novamente');
                      });
                    }else if(snapshot.hasData){
                      //RESGATAR USUAIOS E PERFIS PARA LISTAGEM
                      usuarios = (snapshot.data['usuarios'] as List)
                          .map((e) => UsuarioModel.fromMap(e))
                          .toList();
                      //RESGATAR PERFIS PARA LISTAGEM
                      perfis = (snapshot.data['perfis'] as List)
                          .map((e) => PerfilModel.fromMap(e))
                          .toList();
                    }
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(backgroundImage: AssetImage(foto)),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${usuario.name}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${usuario.perfil != null ? usuario.perfil!.perfil : ""}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Editar',
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.lightBlue
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              onTap: () => navegateForm('Editar', usuario.id),
                            ),
                          ),
                          Divider(),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: TabBar(
                              controller: tabController,
                              indicatorColor: Color(0xff0b1d2b),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Color(0xff0b1d2b),
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                              onTap: (i){
                                if(i == 0 ){
                                  buttonTitle.value = 'Novo Usuário';
                                  modulo = 'usuarios';
                                }else{
                                  buttonTitle.value = 'Novo Perfil';
                                  modulo = 'perfis';
                                }
                              },
                              unselectedLabelColor: Colors.grey,
                              labelPadding: const EdgeInsets.symmetric(vertical: 5),
                              tabs: [
                                Text("Usuários: ${usuarios.length}"),
                                Tab(text: 'Perfis: ${perfis.length}'),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx((){
                                  return ButtonTextWidget(
                                    text: buttonTitle.value,
                                    textColor: Colors.white,
                                    icon: Icons.person_2_rounded,
                                    backgroundColor: Color(0xff0b1d2b),
                                    width: dimensions.width / 3,
                                    action: () => navegateForm('Novo', null),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Divider(),
                          Container(
                            height: dimensions.height * 0.6,
                            color: Colors.white,
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                ListView.builder(
                                  itemCount: usuarios.length,
                                  itemBuilder: (context, index) {
                                    return usuarios.length > 0
                                    ? Dismissible(
                                        key: Key(index.toString()),
                                        background: Container(
                                          color: Colors.amber,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Icon(Icons.edit, color: Colors.black),
                                        ),
                                        secondaryBackground: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Icon(Icons.delete, color: Colors.white),
                                        ),
                                        confirmDismiss: (direction) async {
                                          if (direction == DismissDirection.startToEnd) {
                                            //EDITAR USUARIO
                                            navegateForm('Editar', usuarios[index].id);
                                          } else if (direction == DismissDirection.endToStart) {
                                            //EXIBIR MODAL DE DELETAR
                                            showModalDeletar(context, 'Usuario', usuarios[index].id.toString());
                                          }
                                          return false;
                                        },
                                        child: ListTile(
                                          title: Text('${usuarios[index].name}'),
                                          subtitle: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${usuarios[index].email}'),
                                              if(usuarios[index].perfil != null)
                                                Text('${usuarios[index].perfil!.perfil}'),
                                            ]
                                          ),
                                          /* shape: Border(bottom: BorderSide(width: 1, color: Colors.grey)), */
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Nenhum usuário encontrado.',
                                            style: TextStyle(color: Colors.white,),
                                          )
                                        ),
                                      );
                                  },
                                ),
                                ListView.builder(
                                  itemCount: perfis.length,
                                  itemBuilder: (context, index) {
                                    return perfis.length > 0
                                    ? Dismissible(
                                        key: Key(index.toString()),
                                        background: Container(
                                          color: Colors.amber,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Icon(Icons.edit, color: Colors.black),
                                        ),
                                        secondaryBackground: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Icon(Icons.delete, color: Colors.white),
                                        ),
                                        confirmDismiss: (direction) async {
                                          if (direction == DismissDirection.startToEnd) {
                                            //EDITAR PERFIL
                                            navegateForm('Editar', perfis[index].id);
                                          } else if (direction == DismissDirection.endToStart) {
                                            //EXIBIR MODAL DE DELETAR
                                            showModalDeletar(context, 'Perfil', perfis[index].id.toString());
                                          }
                                          return false;
                                        },
                                        child: ListTile(
                                          title: Text('${perfis[index].perfil}'),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Nenhum perfil encontrado.',
                                            style: TextStyle(color: Colors.white,),
                                          )
                                        ),
                                      );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              ),
            ]
          ) 
        ),
      )
    );
  }
}