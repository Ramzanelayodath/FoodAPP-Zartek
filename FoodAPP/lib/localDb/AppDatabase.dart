
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:foodapp/localDb/Cart.dart';
import 'package:foodapp/localDb/CartDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'AppDatabase.g.dart';

@Database(version: 2, entities: [Cart])
abstract class AppDatabase extends FloorDatabase{

  CartDao get cartDao;
}