import 'package:flutter/material.dart';

class Toasts {
  /// Context must be below any scaffold context
  static void show(BuildContext context, String message, Widget icon) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Row(
        children: [
          IconTheme(data: IconThemeData(color: Colors.white), child: icon),
          SizedBox(width: 12),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ));
  }

  /// Context must be below any scaffold context
  static void showError(BuildContext context, String message) {
    show(context, message, Icon(Icons.error_outline));
  }

  /// Context must be below any scaffold context
  static void showSuccess(BuildContext context, String message) {
    show(context, message, Icon(Icons.check));
  }
}
