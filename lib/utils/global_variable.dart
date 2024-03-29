import 'package:alumniapp/screens/User_List_Screen.dart';
import 'package:alumniapp/screens/alumnipage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alumniapp/screens/add_post_screen.dart';
import 'package:alumniapp/screens/feed_screen.dart';
import 'package:alumniapp/screens/event_screen.dart';
import 'package:alumniapp/screens/profile_screen.dart';
import 'package:alumniapp/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const EventScreen(),
  const AddPostScreen(),
  // const AlumniPage(),
  const SearchScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
