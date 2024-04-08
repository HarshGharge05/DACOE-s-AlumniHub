import 'dart:convert';
import 'dart:developer';

import 'package:alumniapp/models/chat_user.dart';
import 'package:alumniapp/screens/Chat/message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/message.dart';
import '../../resources/auth_methods.dart';

class ChatScreen extends StatefulWidget {

  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //for storing all messages
  List<Message> _list = [];

  //for handling message text change
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),

      body: Column(
        children: [

          Expanded(
            child: StreamBuilder(
              // stream: null,
              stream: AuthMethods.getAllMessages(widget.user),
              builder: (context, snapshot){
            
                switch(snapshot.connectionState){
                //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return SizedBox();
            
                //if some or data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    // log('Data : ${jsonEncode(data![0].data())}');
                    _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            
                    // if(snapshot.hasData){
                    //   final data = snapshot.data?.docs;
                    //   // for(var i in data!){
                    //   //   print('Data : ${jsonEncode(i.data())}');
                    //   //   list.add(i.data()['username']);
                    //   // }
                    //   list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                    // }

            
                    if(_list.isNotEmpty){
                      return ListView.builder(
                        // reverse: true,
                        itemCount: _list.length,
                        padding: EdgeInsets.only(top: 8),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (Context, index){
                          return MessageCard(message: _list[index],);
                        },
                      );
                    }else{
                      return const Center(
                        child: Text('Say Hii!👋',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              },
            ),
          ),

          _chatInput()
        ],
      ),
    );
  }

  //app bar widget
  Widget _appBar(){
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          //back button
          Container(
            padding: EdgeInsets.only(top: 38),
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white,))),

          //user profile picture
          Container(
            padding: EdgeInsets.only(top: 38),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: CachedNetworkImage(
                  width: 45,
                  height: 45,
                  imageUrl: widget.user.photoUrls[0],
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person,),)
              ),
            ),
          ),

           Column(
              // mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user name
                Container(
                    padding: EdgeInsets.only(top: 40, left: 10),
                    child: Text(widget.user.usernames[0], style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),)),

                //last time of user
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Last seen not available!", style: TextStyle(color: Colors.white),))
              ],
            ),
        ],
      ),
    );
  }

  //bottom chat input field
  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 10),
      child: Row(
        children: [
          //input field and buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions, color: Colors.lightBlueAccent.shade400, size: 25)),

                  Expanded(
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Write a message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none
                        ),
                      )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.image, color: Colors.lightBlueAccent.shade400, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt_rounded, color: Colors.lightBlueAccent.shade400, size: 26,))
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
              onPressed: () {
                if(_textController.text.isNotEmpty){
                  AuthMethods.sendMessage(widget.user, _textController.text);
                  _textController.text = '';
                }
              },
            minWidth: 0,
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
            shape: CircleBorder(),
            child: Icon(Icons.send, color: Colors.white,),
            color: Colors.lightBlueAccent.shade400,
          )
        ],
      ),
    );
  }
}
