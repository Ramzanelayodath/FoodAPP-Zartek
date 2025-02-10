import 'package:bloc/bloc.dart';
import 'package:foodapp/localDb/Cart.dart';
import 'package:foodapp/localDb/DbRepository.dart';
import 'package:meta/meta.dart';

part 'CartState.dart';

class CartCubit extends Cubit<CartState> {
  final DbRepository _dbRepository;
  List<Cart> listCartItems = [];
  int totalDish = 0;
  int totalItem = 0;
  int totalPrice = 0;
  CartCubit(this._dbRepository) : super(CartInitial());

  Future<void> getCartItems() async {
     emit(CartItemLoading());
     listCartItems = await _dbRepository.getCartItems();
     totalDish = listCartItems.length;
     totalItem = listCartItems.fold(0, (sum, item) => sum + item.qty);
     totalPrice =  listCartItems.fold(0, (sum, item) => sum + item.totalPrice);
     emit(CartItems(listCartItems,totalDish,totalItem,totalPrice));
  }

  Future<void> onIncrement(Cart cart) async {
    final updatedCart = Cart(
      id: cart.id,
      productName: cart.productName,
      qty: 1,
      singlePrice: double.parse(cart.singlePrice.toString()).toInt(),
      totalPrice: double.parse(cart.singlePrice.toString()).toInt(),
    );

    for (var items in listCartItems) {
      if (items.id == cart.id) {
        items.qty++;
      }
    }
    _dbRepository.upsertCartItem(updatedCart);
   getCartItems();

  }

  Future<void> onDecrement(Cart cart) async {
    final updatedCart = Cart(
      id: cart.id,
      productName: cart.productName,
      qty: -1,
      totalPrice: -double.parse(cart.singlePrice.toString()).toInt(),
      singlePrice: double.parse(cart.singlePrice.toString()).toInt()
    );
    _dbRepository.upsertCartItem(updatedCart);
    getCartItems();
  }

  Future<void> clearCart() async{
     _dbRepository.clearCart();
     getCartItems();
  }
}
