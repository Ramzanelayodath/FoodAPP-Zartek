import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/Strings.dart';
import 'SplashScreenCubit.dart';
import 'SplashScreenState.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<SplashScreenCubit>(context).navigate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: BlocConsumer<SplashScreenCubit, SplashScreenState>(
        listener: (ctx, state) {
          if (state is Navigate) {
            if (state.isLogged) {
              Navigator.pushReplacementNamed(context, "/home");
            } else {
              Navigator.pushReplacementNamed(context, "/login");
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: Text(Strings.appName,style: TextStyle(color: Colors.white,fontSize:17,fontWeight: FontWeight.w500 ),),
          );
        },
      ),
    );
  }
}