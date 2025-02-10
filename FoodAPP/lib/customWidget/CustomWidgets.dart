

import 'package:flutter/material.dart';

class CustomWidgets{

  static void showToast(String message,BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor:Colors.black,
        behavior: SnackBarBehavior.floating, // Floating or fixed position
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void progressDialog(String message,BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Padding(padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),),
            const SizedBox(width: 20),
            Text(message,style: const TextStyle(color: Colors.black),),
          ],
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }

  static void errorDialog(String message,BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}