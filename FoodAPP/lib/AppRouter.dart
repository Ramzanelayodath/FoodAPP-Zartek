
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/HomePage/HomePageCubit.dart';
import 'package:foodapp/Login/Login.dart';
import 'package:foodapp/Login/LoginCubit.dart';
import 'package:foodapp/Login/OtpScreen.dart';
import 'package:foodapp/cartScreen/CartCubit.dart';
import 'package:foodapp/cartScreen/CartScreen.dart';
import 'package:foodapp/localDb/AppDatabase.dart';
import 'package:foodapp/localDb/DbRepository.dart';
import 'package:foodapp/localDb/DbRepositoryImpl.dart';
import 'package:foodapp/network/ApiProvider.dart';
import 'package:foodapp/network/NetworkRepository.dart';
import 'package:foodapp/network/NetworkRepositoryImpl.dart';
import 'package:foodapp/splashScreen/SplashScreen.dart';
import 'package:foodapp/splashScreen/SplashScreenCubit.dart';

import 'HomePage/HomePage.dart';
import 'localStorage/LocalStorage.dart';
import 'localStorage/StorageRepoImpl.dart';
import 'localStorage/StorageRepository.dart';

class AppRouter{
  final LocalStorage _localStorage = LocalStorage();
  final ApiProvider _apiProvider = ApiProvider();
  late final StorageRepository _storageRepository;
  late final NetworkRepository _networkRepository;
  late final DbRepository _dbRepository;

  AppRouter(AppDatabase appDatabase)  {
    _storageRepository = StorageRepoImpl(_localStorage);
    _networkRepository = NetworkRepositoryImpl(_apiProvider);
    _dbRepository = DbRepositoryImpl(appDatabase);
  }
  Route? generateRoute(RouteSettings settings){
    switch(settings.name){
      case  "/" :
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => SplashScreenCubit(_storageRepository),child:const SplashScreen()));
      case "/login" :
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => LoginCubit(_storageRepository),child: Login()));
      case "/home" :
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => HomePageCubit(_networkRepository,_dbRepository,_storageRepository),child: HomePage()));
      case "/cart" :
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => CartCubit(_dbRepository),child: CartScreen()));
      case "/otp":
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => LoginCubit(_storageRepository),child: OtpScrren(settings.arguments as String)));
      default:
        return null;
    }
  }
}
