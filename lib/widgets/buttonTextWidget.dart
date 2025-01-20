import 'package:flutter/material.dart';

class ButtonTextWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final Color? backgroundColor;
  final dynamic icon;
  final double? iconSize;
  final double? width;
  final double? height;
  final bool? disabled;
  final VoidCallback action;
  
  const ButtonTextWidget({
    super.key,
    this.text,
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.iconSize,
    this.width = 40,
    this.height = 40,
    this.disabled = false,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? backgroundColor,
        foregroundColor: textColor ?? textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: text != null
        //CASO EXISTA TEXTO
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              if (icon != null) 
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    icon!, 
                    color: textColor,
                    size: iconSize
                  ),
                ),
              if (text != null) 
                Text(text!),
            ],
          )
        //CASO EXISTA APENAS ICONE
        : Icon(icon!, size: iconSize),
      ),
    );
  }
}