import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? profileName;
  final String? userName;
  final String? imageUrl;
  final String? email;
  final String? bio;

  User({
    required this.id,
    required this.profileName,
    required this.userName,
    required this.imageUrl,
    required this.email,
    required this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      email: doc['email'],
      userName: doc['userName'],
      imageUrl: doc['imageUrl'],
      profileName: doc['profileName'],
      bio: doc['bio'],
    );
  }
}
