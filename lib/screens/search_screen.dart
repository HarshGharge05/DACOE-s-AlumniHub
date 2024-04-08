// import 'package:alumniapp/widgets/alumni_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:alumniapp/screens/profile_screen.dart';

import '../utils/global_variable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  static FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Size screenSize = MediaQuery.of(context).size;
    double textSize = screenSize.width * 0.04;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade100,
        title:
            // Text("OUR Alumni"),
            Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
                labelText: 'Search for Our Alumni...',
                labelStyle: TextStyle(color: Colors.black)),
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.white),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where(
          ['username'][0], isNotEqualTo: auth.currentUser!.uid,
          isGreaterThanOrEqualTo: [searchController.text],
        ).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      uid: (snapshot.data! as dynamic).docs[index]['uid'],
                      // postID: (snapshot.data! as dynamic).docs[index].data(),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15,right: 10, left: 10),
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.brown[50],
                        border: Border.all(
                          color: width > webScreenSize
                              ? Colors.blueGrey
                              : Colors.white,
                        ),
                        // borderRadius: BorderRadius.circular(
                        //     38), // Add border radius for rounded corners
                      ),
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]['photoUrls']
                                    [0],
                              ),
                              radius: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          children: [
                            Text(
                              (snapshot.data! as dynamic).docs[index]['username'][0],
                              style:
                                  TextStyle(color: Colors.black, fontSize: textSize, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              (snapshot.data! as dynamic).docs[index]['description'][0],
                              style:
                              TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ]),
                      // ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

