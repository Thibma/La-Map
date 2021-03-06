import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/response_model.dart';
import 'package:la_map/models/user_model.dart';
import 'package:la_map/models/place_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/google_places_model.dart';

class Network {
  // Malakoff
  final String address = "http://192.168.1.77:8000";

  //final String address = "http://10.33.0.174:8000";

  // Maison
  //final String address = "http://192.168.1.33:8000";
  final Map<String, String> apiToken = {"api-token": "test"};

  ResponseModel apiResponse(http.Response response) {
    if (response.statusCode == 202 || response.statusCode == 400) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.body));
      if (responseModel.error) {
        throw (responseModel.message);
      }

      return responseModel;
    } else if (response.statusCode == 404) {
      throw (404);
    } else {
      throw (response.body);
    }
  }

  // SignIn
  Future<ApiUser> login(String uid) async {
    final response = await http.get(Uri.parse(address + "/users/signin/$uid"),
        headers: apiToken);

    try {
      return ApiUser.fromJson(apiResponse(response).message);
    } catch (e) {
      if (response.statusCode == 404) {
        throw (404);
      }
      throw (apiResponse(response).message);
    }
  }

  // SignUp
  Future<ApiUser> signUp(String pseudo, String uid, String imageUrl) async {
    final response = await http.post(
      Uri.parse(address + "/users"),
      headers: {
        apiToken.keys.first: apiToken.values.first,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {'pseudo': pseudo, 'idFirebase': uid, 'idImage': imageUrl},
    );

    try {
      return ApiUser.fromJson(apiResponse(response).message);
    } catch (e) {
      throw (apiResponse(response).message);
    }
  }

  // Create Place
  Future<Place> createPlace(
      String name,
      String userId,
      String? withWho,
      String? photo,
      LatLng coordinates,
      DateTime date,
      String visibility,
      String? note) async {
    final response = await http.post(
      Uri.parse(address + "/places"),
      headers: {
        apiToken.keys.first: apiToken.values.first,
        "Content-Type": "application/json",
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'userId': userId,
        'withWho': withWho,
        'photo': photo,
        'coordinates': {
          'longitude': coordinates.longitude,
          'latitude': coordinates.latitude,
        },
        'date': date.toIso8601String(),
        'visibility': visibility,
        'note': note
      }),
    );

    try {
      return Place.fromJson(apiResponse(response).message);
    } catch (e) {
      throw (apiResponse(response).message);
    }
  }

  Future<List<Place>> getUserPlaces(String userId) async {
    final response = await http.get(
        Uri.parse(
          address + "/places/$userId",
        ),
        headers: apiToken);
    try {
      List<Place> places = [];
      for (var element in apiResponse(response).message) {
        places.add(Place.fromJson(element));
      }
      return places;
    } catch (e) {
      throw (apiResponse(response).message);
    }
  }

  Future<List<Suggestion>> getAutocompletePlaces(
      String input, String sessionToken) async {
    if (input == "") {
      return [];
    }
    try {
      final response = await http.get(
          Uri.parse(
              "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=fr&key=AIzaSyCC12LH2apk-C8_bVFdD8AQvAlM1ZepAg0&sessiontoken=$sessionToken"),
          headers: apiToken);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          final googleResponse = GoogleMapsResponsePrediction.fromJson(result);
          List<Suggestion> suggestions = [];
          for (var element in googleResponse.predictions) {
            suggestions
                .add(Suggestion(element["place_id"], element["description"]));
          }
          return suggestions;
        }
        if (result['status'] == 'ZERO_RESULTS') {
          return [];
        }
      }

      throw Exception('Failed to fetch suggestion');
    } catch (e) {
      rethrow;
    }
  }

  Future<GooglePlace> getDetailPlace(
      String placeId, String sessionToken) async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyCC12LH2apk-C8_bVFdD8AQvAlM1ZepAg0&sessiontoken=$sessionToken"),
          headers: apiToken);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          final googleResponse = GoogleMapsResponseDetail.fromJson(result);
          return GooglePlace.fromJson(googleResponse.result);
        }
      }

      throw Exception('Failed to fetch suggestion');
    } catch (e) {
      rethrow;
    }
  }
}
