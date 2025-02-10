import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/Login/LoginCubit.dart';

import '../customWidget/CustomWidgets.dart';
import '../utils/Strings.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginCubit,LoginState>(
          listener: (context,state){
            handleListener(state, context);
          },
          child: body(context)
        ,
      ),
    );
  }

  void handleListener(LoginState state,BuildContext context){
     switch(state){
       case LoginProcessing _:
         CustomWidgets.progressDialog(Strings.strWait, context);
       case OTPSend _ :
         ScaffoldMessenger.of(context).hideCurrentSnackBar();
         Navigator.pushNamed(context, '/otp',arguments: state.verificationId);
       case LoginSuccess _:
         ScaffoldMessenger.of(context).hideCurrentSnackBar();
         Navigator.pushReplacementNamed(context, "/home");

     }
  }

  Widget body(BuildContext context){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/firebase.png'),
            SizedBox(height: 20),
            button(
              onTap: () {
                BlocProvider.of<LoginCubit>(context).signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/google.png',
                      height: 25,
                      width: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      Strings.strGoogle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              color: Colors.blueAccent,
            ),
            SizedBox(height: 10),
            button(
              onTap: () {
                BlocProvider.of<LoginCubit>(context).verifyPhoneNumber();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.white, size: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      Strings.strPhone,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget button({
    required VoidCallback onTap,
    required Widget child,
    double borderRadius = 18.0,
    Color color = Colors.white,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: padding,
        margin: margin,
        height: 63,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}
