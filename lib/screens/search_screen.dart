import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Size screenSize = MediaQuery.of(context).size;
    double textSize = screenSize.width * 0.04;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade200,
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
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
              ['username'][0],
              isGreaterThanOrEqualTo: [searchController.text],
            )
            .get(),
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
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: width > webScreenSize
                            ? Colors.blueGrey
                            : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(
                          10), // Add border radius for rounded corners
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrls'][0],
                        ),
                        radius: 48,
                      ),
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        (snapshot.data! as dynamic).docs[index]['username'][0],
                        style:
                            TextStyle(color: Colors.black, fontSize: textSize),
                      ),
                    ]),
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundImage: NetworkImage(
                    //       (snapshot.data! as dynamic).docs[index]['photoUrl'],
                    //     ),
                    //     radius: 48,
                    //   ),
                    //
                    //   title: Text(
                    //     (snapshot.data! as dynamic).docs[index]['username'],
                    //   ),
                    // ),
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
