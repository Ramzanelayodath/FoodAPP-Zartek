

import 'Cart.dart';

abstract class DbRepository{

  Future<List<Cart>> getCartItems();

  Future<void> insertCartItem(Cart cart);

  Future<void> upsertCartItem(Cart cart);

  Future<int?> getProductCount();

  Future<void> clearCart();
}