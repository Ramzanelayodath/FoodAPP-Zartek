
import 'package:floor/floor.dart';


@entity
class Cart {
  @primaryKey
  final int id;

  final String productName;
  int qty;
  final int singlePrice;
  final int totalPrice;

  Cart({
    required this.id,
    required this.productName,
    required this.qty,
    this.singlePrice = 0,
    this.totalPrice = 0,
  });
}
