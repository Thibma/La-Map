class User {
  final String pseudo;
  final String id;
  final String idFirebase;
  final String idImage;
  final List<dynamic> friends;
  //final DateTime lastConnexion;
  //final List<Place> places;

  const User({
    required this.pseudo,
    required this.id,
    required this.idFirebase,
    required this.friends,
    required this.idImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pseudo: json['pseudo'],
      id: json['_id'],
      friends: json['friends'],
      idImage: json['idImage'],
      idFirebase: json['idFirebase'],
    );
  }
}
