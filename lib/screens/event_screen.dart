import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alumniapp/utils/global_variable.dart';
import 'package:alumniapp/widgets/event_card.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
      width > webScreenSize ? Colors.white : Colors.white,
      appBar: width > webScreenSize
          ? null
          : AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.lightBlueAccent.shade100,

          centerTitle: false,
          title: Text("Events",style: TextStyle(color: Colors.black),),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.message_rounded,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: StreamBuilder(

        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(

            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: EventCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}