import 'package:alumniapp/models/chat_user.dart';
import 'package:alumniapp/screens/Chat/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alumniapp/models/user.dart';

import '../../main.dart';

class ChatUserCard extends StatefulWidget {

  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        splashColor: Colors.grey.shade300,
        onTap: () {
          //for navigating to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user,)));
        },
          child: ListTile(

            // splashColor: Colors.white,

            //user profile picture
            // leading: CircleAvatar(child: Icon(CupertinoIcons.person,),),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: CachedNetworkImage(
                width: 45,
                height: 45,
                imageUrl: widget.user.photoUrls[0],
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person,),)
              ),
            ),

            //user name
            title: Text(widget.user.usernames[0],),

            //last message
            subtitle: Text(widget.user.abouts[0], maxLines: 1,),

            //last message time
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.shade400, borderRadius: BorderRadius.circular(10)
              ),
            ),
            //trailing: Text('12:00 PM', style: TextStyle(color: Colors.black54),),
          ),
      ),
    );
  }
}
