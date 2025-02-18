import 'package:flutter/material.dart';

enum SnackBarType { error, success }

class SnackbarUtils {
  GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

  void showSnackbar(String text) {
    Future.delayed(const Duration(seconds: 1), () {
      SnackBar snackbar = SnackBar(
        backgroundColor: const Color(0xfffccfcf),
        content: Text(text,
          style: TextStyle(
            color: const Color(0xffff3f3f)
          ),
        )
      );
      snackbarKey.currentState!.showSnackBar(snackbar);
    });
  }

}

final snackBarUtils = SnackbarUtils();
