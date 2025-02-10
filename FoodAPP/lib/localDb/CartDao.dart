

import 'package:floor/floor.dart';

import 'Cart.dart';

@dao
abstract class CartDao{

  @Query('SELECT * FROM Cart')
  Future<List<Cart>> getCartItems();

  @Query('SELECT * FROM Cart WHERE id = :id')
  Future<Cart?> getCartItemById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCartItem(Cart cart);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateCartItem(Cart cart);

  @Query('SELECT COALESCE(SUM(qty), 0) FROM cart')
  Future<int?> getProductCount();

  @Query('DELETE FROM Cart WHERE id = :id')
  Future<void> deleteCartItem(int id);

  @Query('DELETE FROM Cart')
  Future<void>clearCart();


  @transaction
  Future<void> upsertCartItem(Cart cart) async {
    final existingItem = await getCartItemById(cart.id);

    if (existingItem == null) {
      if (cart.qty > 0) {
        await insertCartItem(cart);
      }
    } else {
      final newQty = existingItem.qty + cart.qty;
      final newTotalPrice = existingItem.totalPrice + cart.totalPrice;

      if (newQty > 0) {
        final updatedCart = Cart(
          id: cart.id,
          productName: cart.productName,
          qty: newQty,
          totalPrice: newTotalPrice,
          singlePrice: cart.singlePrice
        );
        await updateCartItem(updatedCart);
      } else {
        await deleteCartItem(existingItem.id);
      }
    }
  }



}