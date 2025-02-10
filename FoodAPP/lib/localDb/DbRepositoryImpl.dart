

import 'package:foodapp/localDb/AppDatabase.dart';
import 'package:foodapp/localDb/Cart.dart';
import 'package:foodapp/localDb/DbRepository.dart';

class DbRepositoryImpl extends DbRepository{

  final AppDatabase _appDatabase;

  DbRepositoryImpl(this._appDatabase);

  @override
  Future<List<Cart>> getCartItems() {
     return _appDatabase.cartDao.getCartItems();
  }

  @override
  Future<int?> getProductCount() {
     return _appDatabase.cartDao.getProductCount();
  }

  @override
  Future<void> insertCartItem(Cart cart) async {
     _appDatabase.cartDao.insertCartItem(cart);
  }

  @override
  Future<void> upsertCartItem(Cart cart) async {
    _appDatabase.cartDao.upsertCartItem(cart);
  }

  @override
  Future<void> clearCart() async {
     _appDatabase.cartDao.clearCart();
  }
}