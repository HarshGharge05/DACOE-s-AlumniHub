import 'package:alumniapp/models/chat_user.dart';
import 'package:alumniapp/screens/user_profile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../resources/auth_methods.dart';


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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.lightBlueAccent.shade400,
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
                        fontSize: 18, letterSpacing: 0.5, color: Colors.white),

                    //when search text changes then update search list
                    onChanged: (val) {
                      //search logic
                      _searchList.clear();

                      for (var i in list) {
                        if (i.usernames.any((username) => username
                            .toLowerCase()
                            .contains(val.toLowerCase()))) {
                          _searchList.add(i);
                        }
                      }
                      setState(() {});
                    },
                  )
                : Text(
                    "Alumni's",
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
                          user: _isSearching ? _searchList[index] : list[index],
                          uid: _isSearching
                              ? _searchList[index].uid
                              : list[index].uid,
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
