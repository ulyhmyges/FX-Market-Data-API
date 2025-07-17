import 'dart:math';

class Session {
  late String pseudo;
  late bool token_expired;
  late int user_id;

  Session({required this.pseudo, required this.token_expired, required this.user_id});


  factory Session.fromJSON(Map<dynamic, dynamic> json) {
    return Session(
      pseudo: json['pseudo'],
      token_expired:  json['token_expired'],
      user_id: json['user_id']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'pseudo': pseudo,
      'token_expired': token_expired,
      'user_id': user_id
    };
  }
}