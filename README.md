# GS3 Teste - flutter (FRONT-END) - Documentação de uso

Esta é uma aplicação Flutter configurada para atuar como front-end para a aplicação GS3 - laravel.

## Requisitos
Para utilizar a plicação serão necessários:

- Flutter SDK instalado (versão estável mais recente).
- Dart SDK configurado (já incluído no Flutter).
- Um emulador ou dispositivo físico para testes.


### Configuração do projeto
1. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/flutter-laravel-app.git
   ```
2. Navegue para o diretório do projeto Flutter:
   ```bash
   cd flutter-laravel-app
   ```
3. Instale as dependências do Flutter:
   ```bash
   flutter pub get
   ```
4. Ajuste de URLs da API
   Caso vá utilizar um dispositivos fisico para emulação do aplicativo, seguia a seguinte instrução:
   
   - Vá ao arquivo lib/api/api.dart e ajuste a variavel **url** com o endereço de ip e porta na qual o servidor com a api do laravel esteja rodando. 
     
## Executando o Projeto

1. Execute o aplicativo Flutter:
   ```bash
   flutter run
   ```
2. Escolha um dispositivo ou emulador para testar.

  - Dispositivo fisico: Android ou IOS;
  - Emulador de Android;
  - Windows;
  - Chrome;

## Autenticação

1. Para fazer autenticação com usuario padrão no app utilize das seguintes credenciais:

   -**Usuário**: admin@teste.com;
   -**senha**: admin@1234
