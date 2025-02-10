part of 'CartCubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartItemLoading extends CartState{}

class CartItems extends CartState{
   List<Cart> listCart;
   int totalDish;
   int totalItem;
   int totalPrice;
   CartItems(this.listCart,this.totalDish,this.totalItem,this.totalPrice);
}
