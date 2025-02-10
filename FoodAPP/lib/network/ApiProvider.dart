
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'ResponseHandler.dart';
import 'Urls.dart';

class ApiProvider{

    Future<ResponseHandler> getMenu() async{
        final response = await http.get(Uri.parse(Urls.baseUrl+Urls.menu));
        if (response.statusCode == 200) {
          return ResponseHandler.success(jsonDecode(response.body));
        } else {
          return ResponseHandler.error(jsonDecode(response.body));
        }
    }
}