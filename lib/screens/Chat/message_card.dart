import 'dart:math';

import 'package:alumniapp/models/message.dart';
import 'package:alumniapp/screens/Chat/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/auth_methods.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return AuthMethods.currentUser.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
  }

  //sender or another user method
Widget _blueMessage(){

    //update last read message if sender and receiver are different
    if(widget.message.read.isEmpty){
      AuthMethods.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.lightBlueAccent.shade400),
                //making borders curved
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)
                )),
            child: Text(widget.message.msg, style: TextStyle(fontSize: 20, color: Colors.black87),),
          ),
        ),

        //
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent), style: TextStyle(fontSize: 15, color: Colors.black54),),
        )
      ],
    );
}

//our or user message
Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //for adding some space
        // SizedBox(width: 0.1,),

        //double tick blue icon for message read
        if(widget.message.read.isNotEmpty)
          Icon(Icons.done_all_rounded, color: Colors.blue, size: 20,),
        
        // for adding some space
        // SizedBox(width: 0.00001,),

        //sent time
        Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent), style: TextStyle(fontSize: 15, color: Colors.black54),),

        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.lightGreenAccent.shade700),
                //making borders curved
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                )),
            child: Text(widget.message.msg, style: TextStyle(fontSize: 20, color: Colors.black87),),
          ),
        ),
      ],
    );;
}

}
