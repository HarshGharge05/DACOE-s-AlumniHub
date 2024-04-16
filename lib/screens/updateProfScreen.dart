import 'package:alumniapp/resources/auth_methods.dart';
import 'package:alumniapp/screens/profile_screen.dart';
import 'package:alumniapp/utils/utils.dart';
import 'package:alumniapp/widgets/textfieldForUpdateProf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:async';

class updateProfScreen extends StatefulWidget {
  final String uid;
  // final  postID;
  const updateProfScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<updateProfScreen> createState() => _updateProfScreenState();
}

class _updateProfScreenState extends State<updateProfScreen> {
  _updateProfScreenState() {
    defaultProfPhoto();
  }
  // final TextEditingController _updateUsernameController =
  //     TextEditingController();
  final TextEditingController _updateDescriptionController =
      TextEditingController();

  bool _isPressed = false;
  var userData = {};
  bool _isLoading = false;
  bool isLoading = false;
  Uint8List _image = Uint8List(0);
  Uint8List _image1 = Uint8List(0);

  @override
  void initState() {
    super.initState();
    getData();
  }

  void defaultProfPhoto() async {
    String imageUrl =
        "https://i.pinimg.com/564x/36/fa/7b/36fa7b46c58c94ab0e5251ccd768d669.jpg";

    Uint8List imageBytes = await getImageBytes(imageUrl);

    setState(() {
      _image1 = imageBytes;
    });
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void SaveUpdateProf() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().updateUserProf(
        userId: widget.uid,
        // username: _updateUsernameController.text.isEmpty
        //     ? [userData['username'][0]]
        //     : [_updateUsernameController.text],
        description: _updateDescriptionController.text.isEmpty
            ? [userData['description'][0]]
            : [_updateDescriptionController.text],
        files: _image.isEmpty ? [_image1] : [_image]);

    setState(() {
      _isLoading = true;
    });

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  uid: widget.uid,
                )),
      );
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void SaveUpdatechatuser() async {
    // setState(() {
    //   _isLoading = true;
    //
    // });

    String res = await AuthMethods().updateUserchatPost(
        userId: widget.uid,
        // username: _updateUsernameController.text.isEmpty
        //     ? [userData['username'][0]]
        //     : [_updateUsernameController.text],
        description: _updateDescriptionController.text.isEmpty
            ? [userData['description'][0]]
            : [_updateDescriptionController.text],
        files: _image.isEmpty ? [_image1] : [_image]);

    // setState(() {
    //   _isLoading = true;
    // });

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  uid: widget.uid,
                )),
      );
    }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   void SaveUpdatepost() async {
//     setState(() {
//       _isLoading = true;
//
//     });
//
//     String res = await AuthMethods().updateUserPost(
//         userId: widget.uid,
//         username: _updateUsernameController.text.isEmpty
//             ? [userData['username'][0]]
//             : [_updateUsernameController.text],
//         description: _updateDescriptionController.text.isEmpty
//             ? [userData['description'][0]]
//             : [_updateDescriptionController.text],
//         files: _image.isEmpty ? [_image1] : [_image]);
//
//
//     setState(() {
//       _isLoading = true;
//     });
//
//
//     if (res != 'success') {
//       showSnackBar(context, res);
//     } else {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//             builder: (context) => ProfileScreen(
//               uid: widget.uid,
//             )),
//       );
//     }
//   }
//////////////////////////////////////////////////////////////////////////////////////////////////////////

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // postLen = postSnap.docs.length;
      userData = userSnap.data()!;
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white,
                  )),
              backgroundColor: Colors.lightBlueAccent.shade400,
              title: Text(
                // widget.userData['username'],
                'Edit Your Profile',
                style: TextStyle(color: Colors.white),
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
                        _image.isEmpty
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: MemoryImage(_image1),
                                radius: 40,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: MemoryImage(_image),
                                radius: 40,
                              ),
                        Positioned(
                          bottom: -10,
                          left: 45,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            // color: Colors.blueAccent,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    Text(
                      userData['username'][0],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 17),
                    ),

                    // TextFieldInputForProf(
                    //   hintText: 'Update your username',
                    //   textInputType: TextInputType.text,
                    //   textEditingController: _updateUsernameController,
                    // ),

                    const SizedBox(height: 25),

                    TextFieldInputForProf(
                      hintText: 'Update your About section',
                      textInputType: TextInputType.text,
                      textEditingController: _updateDescriptionController,
                    ),

                    const SizedBox(height: 40),

                    Container(
                      height: 60.0,
                      width: 200.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_image.isEmpty) {
                            bool userConfirmed = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          true); // Notify that user confirmed
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          false); // Notify that user cancelled
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                                title: const Text('Are You Sure !!!'),
                                contentPadding: const EdgeInsets.all(20),
                                content:
                                    const Text('Remove Your Profile Picture'),
                              ),
                            );

                            if (userConfirmed == true) {
                              SaveUpdateProf();
                              SaveUpdatechatuser();
                            }
                          } else {
                            SaveUpdateProf();
                            SaveUpdatechatuser();
                          }

                          setState(() {
                            _isPressed = true;
                          });

                          Future.delayed(Duration(milliseconds: 100), () {
                            setState(() {
                              _isPressed = false;
                            });
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (_isPressed) {
                                return Colors
                                    .black.withOpacity(10); // Change color when hovered
                              }
                              return Colors.lightBlueAccent.shade400;
                            },
                          ),
                        ),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              )
                            : const Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),),
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }

  Future<Uint8List> getImageBytes(String imageUrl) async {
    // Fetch the image from the URL
    http.Response response = await http.get(Uri.parse(imageUrl));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Convert the response body to a Uint8List
      Uint8List bytes = response.bodyBytes;
      return bytes;
    } else {
      // If the request failed, return null or handle the error accordingly
      throw Exception('Failed to load image');
    }
  }
}
