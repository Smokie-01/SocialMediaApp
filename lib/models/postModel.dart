import 'package:cloud_firestore/cloud_firestore.dart';
class Post {
  final String postID;
  final String ownerID;
  final String username;
  final String description;
  final String imageURL;
  final int likes;
  final String loaction;
  final String profileImage;

  const Post(
      {required this.postID,
      required this.ownerID,
      required this.username,
      required this.description,
      required this.imageURL,
      required this.likes,
      required this.loaction,
      required this.profileImage});

  factory Post.from(DocumentSnapshot documentSnapshot) {
    return Post(
        postID: documentSnapshot['post_id'],
        ownerID: documentSnapshot['owner_id'],
        username: documentSnapshot['username'],
        description: documentSnapshot['description '],
        imageURL: documentSnapshot['image_url'],
        likes: documentSnapshot[''],
        loaction: documentSnapshot['Location'],
        profileImage: documentSnapshot['profileImage']);
  }
}