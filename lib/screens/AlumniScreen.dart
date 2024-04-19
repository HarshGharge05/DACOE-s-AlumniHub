// // import 'package:alumniapp/widgets/alumni_card.dart';
// import 'package:alumniapp/resources/auth_methods.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:alumniapp/screens/profile_screen.dart';
//
// import '../resources/firestore_methods.dart';
// import '../utils/global_variable.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController searchController = TextEditingController();
//   bool isShowUsers = false;
//
//   static FirebaseAuth auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     Size screenSize = MediaQuery.of(context).size;
//     double textSize = screenSize.width * 0.04;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         // leading: GestureDetector(
//         //   onTap: () => Navigator.pop(context),
//         //   child: Icon(
//         //     Icons.arrow_back,
//         //   ),
//         // ),
//         backgroundColor: Colors.lightBlueAccent.shade400,
//         title:
//             // Text("OUR Alumni"),
//             Form(
//             child: TextFormField(
//             controller: searchController,
//             decoration: const InputDecoration(
//                 labelText: 'Search for Alumni...',
//                 labelStyle: TextStyle(color: Colors.black)),
//             cursorColor: Colors.black,
//             style: TextStyle(color: Colors.white),
//             onFieldSubmitted: (String _) {
//               setState(() {
//                 isShowUsers = true;
//               });
//             },
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//
//         //get all user for alumni page except logged in user
//         stream: FireStoreMethods.firestore.collection('users').where('uid', isNotEqualTo: auth.currentUser!.uid, isGreaterThanOrEqualTo: [searchController.text],).snapshots(),
//         // future: FirebaseFirestore.instance.collection('users').where(['username'][0], isGreaterThanOrEqualTo: [searchController.text],).get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ListView.builder(
//             itemCount: (snapshot.data! as dynamic).docs.length,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 splashColor: Colors.grey.shade300,
//                 onTap: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => ProfileScreen(
//                       uid: (snapshot.data! as dynamic).docs[index]['uid'],
//                       // postID: (snapshot.data! as dynamic).docs[index].data(),
//                     ),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 15,right: 10, left: 10),
//                   child: Card(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     elevation: 0.5,
//                     color: Colors.white,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(
//                           color: width > webScreenSize
//                               ? Colors.blueGrey
//                               : Colors.white,
//                         ),
//                         // borderRadius: BorderRadius.circular(
//                         //     38), // Add border radius for rounded corners
//                       ),
//                       child: Row(children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Container(
//                             child: CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                 (snapshot.data! as dynamic).docs[index]['photoUrls']
//                                     [0],
//                               ),
//                               radius: 30,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 25,
//                         ),
//                         Column(
//                           children: [
//                             Text(
//                               (snapshot.data! as dynamic).docs[index]['username'][0],
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               (snapshot.data! as dynamic).docs[index]['description'][0],
//                               style:
//                               TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal,),
//                             ),
//                           ],
//                         ),
//                       ]),
//                       // ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:alumniapp/models/chat_user.dart';
import 'package:alumniapp/resources/storage_methods.dart';
import 'package:alumniapp/screens/Chat/chat_user_card.dart';
import 'package:alumniapp/screens/user_profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/auth_methods.dart';
import '../../resources/firestore_methods.dart';
// import '../feed_screen.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHome();
}

class _ScreenHome extends State<ScreenHome> {
  //for storing all users
  List<ChatUser> list = [];

  //for storing searched items
  final List<ChatUser> _searchList = [];

  //for storing search status
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simply close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent.shade400,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: _isSearching
                ? TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search for user...",
                  hintStyle:
                  TextStyle(color: Colors.black54, fontSize: 16)),
              autofocus: true,
              style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: Colors.white),

              //when search text changes then update search list
              onChanged: (val) {
                //search logic
                _searchList.clear();

                for (var i in list) {
                  if (i.usernames
                      .any((username) => username
                      .toLowerCase()
                      .contains(val.toLowerCase()))) {
                    _searchList.add(i);
                  }
                }
                setState(() {});
              },
            )
                : Text(
              'ChatUp',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search_outlined))
            ],
          ),
          body: StreamBuilder(
            stream: AuthMethods.getAllUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

              //if some or data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final data = snapshot.data?.docs;
                    list = data
                        ?.map((e) => ChatUser.fromJson(e.data()))
                        .toList() ??
                        [];
                  }

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                      _isSearching ? _searchList.length : list.length,
                      padding: EdgeInsets.only(top: 8),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return UserProfileCard(
                            user:
                            _isSearching ? _searchList[index] : list[index],
                            uid:
                            (snapshot.data! as dynamic).docs[index]['uid']
                            // _isSearching ? (snapshot.data! as dynamic)._searchList[index]['uid'] : (snapshot.data! as dynamic).list[index]['uid']
                            // _isSearching ? _searchList[index] : list[index],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No Connections Found!',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

