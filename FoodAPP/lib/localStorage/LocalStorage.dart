import 'package:get_storage/get_storage.dart';

class LocalStorage{
  final storage = GetStorage();

  void setLoggedIn(bool  status)
  {
    storage.write("loggedIn", status);
  }

  bool getLoggedIn()
  {
    return storage.read("loggedIn") ?? false;
  }


  void setUserName(String name){
    storage.write("name", name);
  }

  String getName(){
     return storage.read("name") ?? '';
  }

  void setFirebaseUID(String id){
     storage.write('uID', id);
  }

  String getFirebaseUID(){
     return storage.read('uID') ?? '';
  }
}