import 'package:flutter/material.dart';

class AlumniPage extends StatefulWidget {
  const AlumniPage({super.key});

  @override
  State<AlumniPage> createState() => _AlumniPageState();
}

class _AlumniPageState extends State<AlumniPage> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Form(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[300], // Adjust the color as needed
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                onChanged : _onSearchChanged,
                decoration:
                const InputDecoration(
                    labelText: 'Search for a user...',
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20
                    ),

                ),
                    style: TextStyle(color: Colors.blue),
                // onFieldSubmitted: (String _) {
                //   setState(() {
                //     isShowUsers = true;
                //   }
                ),
            ),

            ),
          ),
        );

}

void _onSearchChanged (String _){
  setState(() {
        isShowUsers = true;
      });
}

}