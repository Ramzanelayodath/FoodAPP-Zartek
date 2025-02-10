
import 'package:foodapp/localStorage/LocalStorage.dart';
import 'package:foodapp/localStorage/StorageRepository.dart';


class StorageRepoImpl implements StorageRepository{
  LocalStorage localStorage;

  StorageRepoImpl(this.localStorage);

  @override
  bool getLoggedIn() {
     return localStorage.getLoggedIn();
  }

  @override
  String getName() {
     return localStorage.getName();
  }

  @override
  void setLoggedIn(bool status) {
    localStorage.setLoggedIn(status);
  }

  @override
  void setName(String name) {
    localStorage.setUserName(name);
  }

  @override
  void setFirebaseUID(String id) {
    localStorage.setFirebaseUID(id);
  }

  @override
  String getFirebaseUID() {
    return localStorage.getFirebaseUID();
  }


}