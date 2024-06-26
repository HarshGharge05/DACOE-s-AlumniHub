// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class User {
//   final String email;
//   final String uid;
//   final String photoUrl;
//   final String username;
//   final String description;
//   final List followers;
//   final List following;
//
//   const User(
//       {required this.username,
//       required this.uid,
//       required this.photoUrl,
//       required this.email,
//       required this.description,
//       required this.followers,
//       required this.following});
//
//   static User fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//
//     return User(
//       username: snapshot["username"],
//       uid: snapshot["uid"],
//       email: snapshot["email"],
//       photoUrl: snapshot["photoUrl"],
//       description: snapshot["description"],
//       followers: snapshot["followers"],
//       following: snapshot["following"],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         "username": username,
//         "uid": uid,
//         "email": email,
//         "photoUrl": photoUrl,
//         "description": description,
//         "followers": followers,
//         "following": following,
//       };
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String uid;
  final List<String> photoUrl; // Change here
  final List<String> username;
  final List<String> description;
  final List followers;
  final List following;

  const Users({
    required this.username,
    required this.uid,
    required this.photoUrl, // Change here
    required this.email,
    required this.description,
    required this.followers,
    required this.following,
  });


  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      username:  List<String>.from(snapshot["username"]),
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: List<String>.from(snapshot["photoUrls"]), // Change here
      description:  List<String>.from(snapshot["description"]),
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "photoUrls": photoUrl, // Change here
    "description": description,
    "followers": followers,
    "following": following,
  };
}
