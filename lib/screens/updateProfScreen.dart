import 'package:alumniapp/utils/utils.dart';
import 'package:alumniapp/widgets/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class updateProfScreen extends StatefulWidget {
  final String uid;
  const updateProfScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<updateProfScreen> createState() => _updateProfScreenState();
}

class _updateProfScreenState extends State<updateProfScreen> {

  final TextEditingController _updateUsernameController = TextEditingController();
  final TextEditingController _updateDescriptionController = TextEditingController();

  bool _isLoading = false;
  var userData = {};
  // int postLen = 0;
  // int followers = 0;
  // int following = 0;
  // bool isFollowing = false;
  bool isLoading = false;
  Uint8List _image = Uint8List(0);

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      // var postSnap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .get();

      // postLen = postSnap.docs.length;
      userData = userSnap.data()!;

      // followers = userSnap.data()!['followers'].length;
      // following = userSnap.data()!['following'].length;
      // isFollowing = userSnap
      //     .data()!['followers']
      //     .contains(FirebaseAuth.instance.currentUser!.uid);
      // setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                // widget.userData['username'],
                'Edit Your Profile',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: false,
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(56),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userData['photoUrls'][0],
                          ),
                          radius: 40,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 45,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            // color: Colors.blueAccent,
                          ),
                        )
                      ],
                    ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   padding: const EdgeInsets.only(
                    //     top: 15,
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       userData['username'][0],
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.black,
                    //           fontSize: 17),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 25),

                    TextFieldInput(
                      hintText: '${userData['username'][0]}',
                      textInputType: TextInputType.text,
                      textEditingController: _updateUsernameController,


                    ),
                    const SizedBox(height: 25),

                    TextFieldInput(
                      hintText: '${userData['description'][0]}',
                      textInputType: TextInputType.text,
                      textEditingController: _updateDescriptionController,


                    ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   padding: const EdgeInsets.only(
                    //     top: 1,
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       userData['description'][0],
                    //       style: TextStyle(color: Colors.blue),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(52),
                              ),
                            ),
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }
}
