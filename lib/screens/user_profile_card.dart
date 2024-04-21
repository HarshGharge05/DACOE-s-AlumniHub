import 'package:alumniapp/models/chat_user.dart';
import 'package:alumniapp/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserProfileCard extends StatefulWidget {

  final ChatUser user;
  final String uid;


  const UserProfileCard({super.key, required this.user, required this.uid});

  @override
  State<UserProfileCard> createState() => _UserProfileCard();
}

class _UserProfileCard extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        splashColor: Colors.white,
        onTap: () {
          //for navigating to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(
                      uid: widget.uid
                    ),));
        },
        child: ListTile(


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
        ),
      ),
    );
  }
}
