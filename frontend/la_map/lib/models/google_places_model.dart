class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(json["place_id"], json["description"]);
  }
}

class GooglePlace {
  double longitude;
  double latitude;

  GooglePlace({
    required this.longitude,
    required this.latitude,
  });

  factory GooglePlace.fromJson(Map<String, dynamic> json) {
    return GooglePlace(
        longitude: json["geometry"]["location"]["lng"],
        latitude: json["geometry"]["location"]["lat"]);
  }
}

class GoogleMapsResponsePrediction {
  final List<dynamic> predictions;
  final String status;

  GoogleMapsResponsePrediction(this.predictions, this.status);

  factory GoogleMapsResponsePrediction.fromJson(Map<String, dynamic> json) {
    return GoogleMapsResponsePrediction(json["predictions"], json["status"]);
  }
}

class GoogleMapsResponseDetail {
  final Map<String, dynamic> result;
  final String status;

  GoogleMapsResponseDetail(this.result, this.status);

  factory GoogleMapsResponseDetail.fromJson(Map<String, dynamic> json) {
    return GoogleMapsResponseDetail(json["result"], json["status"]);
  }
}
