class ApiUser {
  final String pseudo;
  final String id;
  final String idFirebase;
  final String idImage;
  final List<dynamic> friends;
  //final DateTime lastConnexion;

  const ApiUser({
    required this.pseudo,
    required this.id,
    required this.idFirebase,
    required this.friends,
    required this.idImage,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      pseudo: json['pseudo'],
      id: json['_id'],
      friends: json['friends'],
      idImage: json['idImage'],
      idFirebase: json['idFirebase'],
    );
  }
}
