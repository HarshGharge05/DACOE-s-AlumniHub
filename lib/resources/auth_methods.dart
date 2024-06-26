import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alumniapp/models/user.dart' as model;
import 'package:alumniapp/resources/storage_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/chat_user.dart';
import '../models/message.dart';
import 'firestore_methods.dart';

class AuthMethods {
   //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing firebase storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // to return current user
  static User get currentUser => auth.currentUser!;


  // get user details
  Future<model.Users> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();

    return model.Users.fromSnap(documentSnapshot);
  }



  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<String> signUpUser({
    required String email,
    required String password,
    required List<String> username,
    required List<String> description,
    required List<Uint8List> files, // Change here
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          description.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        List<String> photoUrls = [];
        for (Uint8List file in files) {
          String photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
          photoUrls.add(photoUrl);
        }

        model.Users user = model.Users(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrls,
          email: email,
          description: description,
          followers: [],
          following: [],
        );

        // adding user in our database
        await firestore.collection("users").doc(cred.user!.uid).set(user.toJson());


        //for creating a user for chatuser collection on firebase
        createUser(username, email,  photoUrls, description);

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }



  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  //for checking if user exist or not?


  //for creating a user for chatuser collection on firebase
  static Future<void> createUser(List<String> username, String email, List<String> photoUrl, List<String> description) async {

    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        photoUrls: photoUrl,
        uid:  currentUser.uid,
        createdAt: time,
        abouts: description,
        lastActive: time,
        // isOnline: "",
        email: email,
        pushToken: '',
        usernames: username
    );



    await firestore
        .collection('chatusers')
        .doc(auth.currentUser!.uid)
        .set(chatUser.toJson());
  }

  //get all user for chat page except logged in user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(){
    return FireStoreMethods.firestore.collection('chatusers').where('uid', isNotEqualTo: auth.currentUser!.uid).snapshots();
  }

  //************************chat screen related APIs****************************

  //useful for getting coversation Id
  static String getConversationID(String id) => currentUser.uid.hashCode <= id.hashCode
      ? '${currentUser.uid}_$id'
      : '${id}_${currentUser.uid}';


  //for getting all messages of a specific for conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .snapshots();
  }

//for sending message
//   static Future<void> sendMessage(ChatUser chatUser, String msg) async {
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {

    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        msg: msg,
        read: '',
        toId: chatUser.uid,
        // toId: '9BS8sqgbcuSj470JOtKZS1Fbg2F2',
        type: Type.text,
        sent: time,
        fromId: currentUser.uid
    );

    // final ref = firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
    // await ref.doc(time).set(message.toJson());
    final ref = firestore.collection('chats/${getConversationID(chatUser.uid)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore.collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read ': DateTime.now().millisecondsSinceEpoch.toString()});

  }

//chats (collection) --> conversation_id(doc) --> messages(collection) --> message(doc)


  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  Future<String> updateUserProf({
    required String userId,
    // required List<String> username,
    required List<String> description,
    required List<Uint8List> files, // Change here
  }) async {
    String res = "Some error Occurred";
    try {
      if(description.isNotEmpty && files.isNotEmpty ) {

        List<String> photoUrls1 = [];
        for (Uint8List file in files) {
          String photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
          photoUrls1.add(photoUrl);
        }

        Map<String, dynamic> userData = {
          // 'username': username,
          'photoUrls': photoUrls1, // Store URLs in Firestore
          'description': description,
          // 'username': username,

        };

        await FirebaseFirestore.instance.collection('users').doc(userId).update(userData);

        res = "success";
      }
      else{
        res = "Please enter all the fields";
      }

    } catch (err) {
      return err.toString();
    }
    return res;
  }

  //
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserForalumi(){
  //   return FireStoreMethods.firestore.collection('users').where('uid', isNotEqualTo: auth.currentUser!.uid).snapshots();
  // }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  Future<String> updateUserchatPost({
    required String userId,
    // required List<String> username,
    required List<String> description,
    required List<Uint8List> files, // Change here
  }) async {
    String res = "Some error Occurred";
    try {
      if(files.isNotEmpty ) {

        List<String> photoUrls1 = [];
        for (Uint8List file in files) {
          String photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
          photoUrls1.add(photoUrl);
        }

        Map<String, dynamic> userData = {
          'photoUrls': photoUrls1,
          'abouts': description,
          // 'usernames': username,

          // Store URLs in Firestore
        };

        await FirebaseFirestore.instance.collection('chatusers').doc(userId).update(userData);


        res = "success";
      }
      else{
        res = "Please enter all the fields";
      }

    } catch (err) {
      return err.toString();
    }
    return res;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   Future<String> updateUserPost({
//     required String userId,
//     required List<String> username,
//     required List<String> description,
//     required List<Uint8List> files, // Change here
//   }) async {
//     String res = "Some error Occurred";
//     try {
//       if(files.isNotEmpty ) {
//
//         List<String> photoUrls1 = [];
//         for (Uint8List file in files) {
//           String photoUrl = await StorageMethods()
//               .uploadImageToStorage('profilePics', file, false);
//           photoUrls1.add(photoUrl);
//         }
//
//         Map<String, dynamic> userData = {
//           'photoUrls': photoUrls1,
//           // 'abouts': description,
//           'username': username,
//
//           // Store URLs in Firestore
//         };
//
//         await FirebaseFirestore.instance.collection('posts').doc(userId).update(userData);
//
//
//         res = "success";
//       }
//       else{
//         res = "Please enter all the fields";
//       }
//
//     } catch (err) {
//       return err.toString();
//     }
//     return res;
//   }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // Future<String> updateUserEvents({
  //   required String userEventId,
  //   required List<String> username,
  //   required List<Uint8List> files, // Change here
  // }) async {
  //   String res = "Some error Occurred";
  //   try {
  //     if(username.isNotEmpty  && files.isNotEmpty ) {
  //
  //       List<String> photoUrls1 = [];
  //       for (Uint8List file in files) {
  //         String photoUrl = await StorageMethods()
  //             .uploadImageToStorage('profilePics', file, false);
  //         photoUrls1.add(photoUrl);
  //       }
  //
  //       Map<String, dynamic> userData = {
  //         'username': username,
  //         'photoUrl': photoUrls1, // Store URLs in Firestore
  //       };
  //
  //       await FirebaseFirestore.instance.collection('events').doc(userEventId).update(userData);
  //
  //       res = "success";
  //     }
  //     else{
  //       res = "Please enter all the fields";
  //     }
  //
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////