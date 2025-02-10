import 'package:bloc/bloc.dart';
import 'package:foodapp/homePage/Data/MenuResponse.dart';
import 'package:foodapp/localDb/Cart.dart';
import 'package:foodapp/localDb/DbRepository.dart';
import 'package:foodapp/localStorage/StorageRepository.dart';
import 'package:foodapp/network/NetworkRepository.dart';
import 'package:meta/meta.dart';


part 'HomePageState.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final NetworkRepository _networkRepository;
  final DbRepository _dbRepository;
  final StorageRepository _storageRepository;
  String username = "";
  String userFirebaseId = "";
  HomePageCubit(this._networkRepository,this._dbRepository,this._storageRepository) : super(HomePageInitial());
  List<Category> listCategory = [];


  Future<void> getMenu() async{
     emit(MenuLoading());
     int? totalCartItem = await getTotalCartItem();
     final response = await _networkRepository.getMenu();
     if(response.success){
         final data = MenuResponse.fromJson(response.data);
         listCategory = data.categories;
         emit(MenuLoaded(listCategory,totalCartItem!));
     }else{
         emit(MenuDownloadedError(response.error));
     }
  }

  Future<void> onIncrement(Dish dish) async {
    final updatedCart = Cart(
      id: dish.id,
      productName: dish.name,
      qty: 1,
      totalPrice: double.parse(dish.price).toInt(),
      singlePrice: double.parse(dish.price).toInt()
    );

    for (var category in listCategory) {
      for (var d in category.dishes) {
        if (d.id == dish.id) {
          d.qty++;
        }
      }
    }
    _dbRepository.upsertCartItem(updatedCart);
    int? totalCartItem = await getTotalCartItem();
    emit(MenuLoaded(listCategory,totalCartItem!));

  }

  Future<void> onDecrement(Dish dish) async {
    final updatedCart = Cart(
      id: dish.id,
      productName: dish.name,
      qty: -1,
      totalPrice: -double.parse(dish.price).toInt(),
      singlePrice: double.parse(dish.price).toInt()
    );
    for (var category in listCategory) {
      for (var d in category.dishes) {
        if (d.id == dish.id) {
          d.qty--;
        }
      }
    }
    _dbRepository.upsertCartItem(updatedCart);
    int? totalCartItem = await getTotalCartItem();
    emit(MenuLoaded(listCategory,totalCartItem!));
  }

  Future<int?> getTotalCartItem(){
     return _dbRepository.getProductCount();
  }

  void logout(){
    _storageRepository.setLoggedIn(false);
    emit(LogoutSuccess());
  }

  void getUserDetails(){
     username = _storageRepository.getName();
     userFirebaseId = _storageRepository.getFirebaseUID();
     emit(UserDetails(username, userFirebaseId));
  }

}
