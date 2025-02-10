part of 'HomePageCubit.dart';

@immutable
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class MenuLoading extends HomePageState{}

class MenuLoaded extends HomePageState{
  List<Category> listMenu;
  int totalCartItemQty;

  MenuLoaded(this.listMenu,this.totalCartItemQty);
}

class MenuDownloadedError extends HomePageState{
    String error;

    MenuDownloadedError(this.error);
}

class UserDetails extends HomePageState{
   String userName;
   String userFirebaseId;

   UserDetails(this.userName, this.userFirebaseId);

}

class LogoutSuccess extends HomePageState{}


