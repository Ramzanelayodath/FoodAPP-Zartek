
import 'package:foodapp/network/ApiProvider.dart';
import 'package:foodapp/network/NetworkRepository.dart';
import 'package:foodapp/network/ResponseHandler.dart';

class NetworkRepositoryImpl implements NetworkRepository{

  final ApiProvider _apiProvider;

  NetworkRepositoryImpl(this._apiProvider);

  @override
  Future<ResponseHandler> getMenu() {
     return _apiProvider.getMenu();
  }
}