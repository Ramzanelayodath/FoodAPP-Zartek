

import 'ResponseHandler.dart';

abstract class NetworkRepository{

  Future<ResponseHandler> getMenu();
}