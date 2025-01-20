import 'package:flutter/material.dart';

class InputTextWidget extends StatefulWidget {
  final String name;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? sufixIcon;
  final String? placeholder;
  final Function? onChanged;
  final Function? onSaved;
  final TextInputType? type;
  final int? maxLength;
  final Function? validator;
  final dynamic controller;
  final TextEditingController textController;

  const InputTextWidget({
    super.key,
    required this.name, 
    this.label,
    this.hint,
    this.prefixIcon,
    this.sufixIcon,
    this.placeholder,
    this.onChanged,
    this.onSaved,
    this.type,
    this.maxLength,
    this.validator,
    required this.textController, 
    required this.controller, 
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  //VARIAVEL DE EXIBIÇÃO DE SENHA
  bool visible = false;
  //VARIAVEL DE EXIBIÇÃO DE BOTÃO DE VISIBILIDADE DE SENHA
  bool obscure = false;
  //VARIAVEL PARA CONTROLAR EXIBIÇÃO ICONE NO FIM DO INPUT
  Icon? prefixIcon;
  //VARIAVEL PARA CONTROLAR EXIBIÇÃO ICONE NO FIM DO INPUT
  Icon? sufixIcon;

  @override
  void initState() {
    super.initState();
    //INICIALIZR VISIBILIDADE DE SENHA CASO EXISTA
    obscure = widget.type != null && widget.type == TextInputType.visiblePassword;
    visible = widget.type != null && widget.type == TextInputType.visiblePassword;
    //INICIALIZAR ICONS
    prefixIcon = widget.prefixIcon != null ? Icon(widget.prefixIcon) : null;
    sufixIcon = widget.sufixIcon != null ? Icon(widget.sufixIcon) : null;
  }

  void showText(){
    setState(() {
      visible = !visible;
      sufixIcon = visible
       ? Icon(Icons.visibility_off) 
       : Icon(Icons.visibility);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.textController,
        keyboardType: widget.type,
        textCapitalization: widget.maxLength != null ? TextCapitalization.characters : TextCapitalization.none,
        obscureText: visible,
        maxLength: widget.maxLength ?? widget.maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          errorMaxLines: 3,
          prefixIconColor: Colors.grey,
          suffixIconColor: Colors.grey,
          errorStyle: const TextStyle(
            fontStyle: FontStyle.normal
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold,
          ),
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: widget.hint,
          labelText: widget.label,
          prefixIcon: prefixIcon,
          suffixIcon: sufixIcon != null 
            ? IconButton(
              icon: sufixIcon!,
              onPressed: () => showText(),
            )
            : null
        ),
        onChanged: (value){
          if(widget.onChanged != null){
            widget.onChanged!(value);
          }
        },
        onSaved: (value){
          if(widget.onSaved != null){
            widget.onSaved!({widget.name:  value});
          }
        },
        validator: (value) {
          //DEFINIR VARIAVEL DE RESULTADO DA VALIDAÇÃO
          String? result;
          //VERIFICAR SE SERÁ USADA FUNÇÃO PERSOLNIZADA DE VALIDAÇÃO
          if(widget.validator != null){
            result = widget.validator!();
          }else{
            //VERIFICAR SE HINT FOI RECEBIDO
            if(widget.hint != null){
              result = widget.controller.validateEmpty(value, widget.hint);
            }else{
              result = widget.controller.validateEmpty(value, widget.label);
            }
          }
          //FOCAR INPUT 
          FocusScope.of(context).autofocus(FocusNode());
          //RETURNAR RESULTADO DA VALIDAÇÃO
          return result;
        },
      ),
    );
  }
}