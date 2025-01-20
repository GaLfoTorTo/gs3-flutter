import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final VoidCallback? leftAction;
  final VoidCallback? rightAction;

  const HeaderWidget({
    super.key, 
    this.title, 
    this.leftAction, 
    this.rightAction, 
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0b1d2b),
      title:Text(
        title!,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.normal
        ),
      ),
      leading: leftAction != null ? 
        BackButton(color: Colors.white,)
        : null,
      actions: rightAction != null
        ? [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: rightAction!,
            )
          ]
        : [], 
      elevation: 8,
      shadowColor: Colors.grey.withValues(alpha: 0.7),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}