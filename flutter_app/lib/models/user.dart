class User {
  final String pseudo;
  final String password;

  User({required this.pseudo, required this.password});

  factory User.fromJSON(Map<dynamic, dynamic> json) {
    return User(
        pseudo: json['pseudo'],
        password: json['password']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'pseudo': pseudo,
      'password': password
    };
  }
}