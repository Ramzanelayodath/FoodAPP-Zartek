import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../customWidget/CustomWidgets.dart';
import '../utils/Strings.dart';
import 'LoginCubit.dart';

class OtpScrren extends StatelessWidget{
  late final TextEditingController pinController = TextEditingController();
  static const focusedBorderColor = Colors.green;
  static const fillColor = Colors.green;
  static const borderColor = Colors.green;
  String verificationId;

  OtpScrren(this.verificationId);

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: borderColor),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  BlocListener<LoginCubit,LoginState>(
        listener: (context,state){
          handleListener(state, context);
        },
        child: body(context)
      )
    );
  }

  Widget body(BuildContext context){
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(Strings.strOTP,style: TextStyle(fontSize: 16),),
           SizedBox(height: 8,),
           Directionality(
             textDirection: TextDirection.ltr,
             child: Pinput(
               length: 6,
               controller: pinController,
               defaultPinTheme: defaultPinTheme,
               separatorBuilder: (index) => const SizedBox(width: 8),
               validator: (value) {},
               onCompleted: (pin) {
                 debugPrint('onCompleted: $pin');
               },
               onChanged: (value) {
                 debugPrint('onChanged: $value');
               },
               cursor: Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   Container(
                     margin: const EdgeInsets.only(bottom: 9),
                     width: 22,
                     height: 1,
                     color: focusedBorderColor,
                   ),
                 ],
               ),
               focusedPinTheme: defaultPinTheme.copyWith(
                 decoration: defaultPinTheme.decoration!.copyWith(
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: focusedBorderColor),
                 ),
               ),
               submittedPinTheme: defaultPinTheme.copyWith(
                 decoration: defaultPinTheme.decoration!.copyWith(
                   color: fillColor,
                   borderRadius: BorderRadius.circular(19),
                   border: Border.all(color: focusedBorderColor),
                 ),
               ),
               errorPinTheme: defaultPinTheme.copyBorderWith(
                 border: Border.all(color: Colors.redAccent),
               ),
             ),
           ),
           SizedBox(height: 10,),
           InkWell(
             child: Container(
               width: double.infinity,
               height: 75,
               decoration: BoxDecoration(
                 color: Colors.green,
                 borderRadius: BorderRadius.circular(16),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black26,
                     blurRadius: 8,
                     spreadRadius: 2,
                     offset: Offset(2, 4),
                   ),
                 ],
               ),
               child: Center(
                   child: Text(Strings.strVerify,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
             ),
             onTap: (){
                BlocProvider.of<LoginCubit>(context).signInWithOTP(pinController.text.toString(),verificationId);
             },
           ),
         ],
       ),
     );
  }

  void handleListener(LoginState state, BuildContext context){
      switch(state){
        case LoginProcessing _:
          CustomWidgets.progressDialog(Strings.strWait, context);
          break;
        case LoginSuccess _:
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pushReplacementNamed(context, "/home");
          break;

      }
  }


}