// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:alumniapp/models/event.dart';
import 'package:alumniapp/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethodsForEvent {
  final FirebaseFirestore _firestoreForEvent = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('events', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Event post = Event(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestoreForEvent.collection('events').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestoreForEvent.collection('events').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestoreForEvent.collection('events').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postCommentforEvent(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestoreForEvent
            .collection('events')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestoreForEvent.collection('events').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//   Future<void> followUser(String uid, String followId) async {
//     try {
//       DocumentSnapshot snap =
//       await _firestoreForEvent.collection('users').doc(uid).get();
//       List following = (snap.data()! as dynamic)['following'];
//
//       if (following.contains(followId)) {
//         await _firestoreForEvent.collection('users').doc(followId).update({
//           'followers': FieldValue.arrayRemove([uid])
//         });
//
//         await _firestoreForEvent.collection('users').doc(uid).update({
//           'following': FieldValue.arrayRemove([followId])
//         });
//       } else {
//         await _firestoreForEvent.collection('users').doc(followId).update({
//           'followers': FieldValue.arrayUnion([uid])
//         });
//
//         await _firestoreForEvent.collection('users').doc(uid).update({
//           'following': FieldValue.arrayUnion([followId])
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) print(e.toString());
//     }
//   }
}
