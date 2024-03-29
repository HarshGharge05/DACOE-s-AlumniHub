import 'package:alumniapp/Bottom_NavigationBar/curved_navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alumniapp/utils/global_variable.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
        buttonBackgroundColor: Colors.lightBlue.shade100,
        height: 60,
        color: Colors.grey.shade400,

        items: const <Widget>[
          Icon(Icons.home_outlined, color: Colors.black,),
          Icon(Icons.event_note_rounded, color: Colors.black),
          Icon(Icons.add_box, color: Colors.black),
          Icon(Icons.school_outlined, color: Colors.purple),
          Icon(Icons.person_outline, color: Colors.black),
        ],
        onTap: navigationTapped,
        // currentIndex: _Page,
      ),
      // body: controller.screens[controller.selectedIndex.value],
    );
  }
}
