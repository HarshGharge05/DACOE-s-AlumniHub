import 'package:alumniapp/Bottom_NavigationBar/curved_navigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alumniapp/utils/global_variable.dart';

  class MobileScreenLayout extends StatefulWidget {
    const MobileScreenLayout({super.key});

    @override
    State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
  }

  class _MobileScreenLayoutState extends State<MobileScreenLayout> {
    int _Page = 0;
    late PageController pageController;


    @override
    void initState() {
      super.initState();
      pageController = PageController();
    }


    @override
    void dispose() {
      pageController.dispose();
      super.dispose();
    }


    void onPageChanged(int index) {
      setState(() {
        _Page = index;
      });
    }

    void navigationTapped(int index) {
      //Animating Page
      pageController.jumpToPage(index);
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
        ),

        bottomNavigationBar: CurvedNavigationBar(
          // animationCurve: Curves.easeInOutBack,
          animationDuration: const Duration(milliseconds: 500),
          index: 0,

          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.lightBlueAccent,
          height: 60,
          color: Colors.lightBlueAccent.shade100,

          items: const <Widget>[
            Icon(Icons.home_outlined, color: Colors.black,),
            Icon(Icons.event_note_rounded, color: Colors.black),
            Icon(Icons.add_box, color: Colors.black),
            Icon(Icons.school_outlined, color: Colors.white),
            Icon(Icons.person_outline, color: Colors.black),
          ],
          onTap: navigationTapped,
          // currentIndex: _Page,
        ),
        // body: controller.screens[controller.selectedIndex.value],
      );
    }
  }
