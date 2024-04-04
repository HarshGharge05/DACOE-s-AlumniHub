import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String description;
  final List followers;
  final List following;
  // final String createdAt;
  // late final String lastActive;
  // final bool isOnline;
  // final String pushToken;


  Users(
      {
        required this.username,
        required this.uid,
        required this.photoUrl,
        required this.email,
        required this.description,
        required this.followers,
        required this.following,
        // required this.createdAt,
        // required this.lastActive,
        // required this.isOnline,
        // required this.pushToken,
      });

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      description: snapshot["description"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      // createdAt = snapshot["created_at"],
      // lastActive = snapshot["last_active"]
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "description": description,
        "followers": followers,
        "following": following,
        // "created_at" : createdAt
        // "last_active" : lastActive
      };
}
