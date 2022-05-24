import 'package:la_map/models/response_model.dart';
import 'package:la_map/models/user_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Network {
  final String address = "http://192.168.1.143:8000";
  final Map<String, String> apiToken = {"api-token": "test"};

  ResponseModel apiResponse(http.Response response) {
    if (response.statusCode == 202 || response.statusCode == 400) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.body));
      if (responseModel.error) {
        throw (responseModel.message);
      }

      return responseModel;
    } else {
      throw (response.body);
    }
  }

  Future<UserModel> login(String uid) async {
    final response = await http.get(Uri.parse(address + "/users/signin/$uid"),
        headers: apiToken);

    try {
      return UserModel.fromJson(apiResponse(response).message);
    } catch (e) {
      throw (apiResponse(response).message);
    }
  }
}
