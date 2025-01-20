class AppApi {
  //URL BASE DAS REQUISIÇÕES
  static final url = 'http://10.1.10.154:8000/api/';
  //ROTAS DE USUÁRIO
  static const listarUsuario = 'usuarios';
  static const salvarUsuario = 'usuarios/salvar';
  static const editarUsuario = 'usuarios/editar/';
  static const deletarUsuario = 'usuarios/deletar/';
  //ROTAS DE PERFIL
  static const listarPerfil = 'perfis';
  static const salvarPerfil = 'perfis/salvar';
  static const editarPerfil = 'perfis/editar/';
  static const deletarPerfil = 'perfis/deletar/';
  static const atribuirPerfil = 'perfis/atribuir/';
}