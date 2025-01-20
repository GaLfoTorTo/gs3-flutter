import 'package:flutter/material.dart';

class AlertMessageWidget {
  static SnackBar createSnackBar({
    required String message,
    required String type,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: type == 'Success' ? Colors.green : Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
    );
  }
}
