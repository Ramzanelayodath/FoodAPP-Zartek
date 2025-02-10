import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/utils/Strings.dart';
import 'package:get_storage/get_storage.dart';

import 'AppRouter.dart';
import 'localDb/AppDatabase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase database = await $FloorAppDatabase.databaseBuilder('foodapp.db').build();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp( MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;
  late final AppRouter _router;

  MyApp(this.appDatabase, {super.key}) {
    _router = AppRouter(appDatabase);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => _router.generateRoute(settings,),
      initialRoute: '/',
    );
  }
}

