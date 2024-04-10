import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alumniapp/providers/user_provider.dart';
import 'package:alumniapp/resources/firestore_methods.dart';
import 'package:alumniapp/resources/firestore_method_for_Event.dart';
import 'package:alumniapp/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _fileforpost;
  Uint8List? _fileforevent;
  // Uint8List _image =Uint8List(0);
  bool isLoading = false;
  int f = 0;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _descriptionControllerforEvent = TextEditingController();

  //--------------------------------------------------------For Post----------------------------------------------------------------------------------
  _selectImageForPost(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _fileforpost = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _fileforpost = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, List<String> username, List<String> profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        [_descriptionController.text],
        _fileforpost!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImageForPostAndEvent();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
          // showSnackBar(context, 'err in firestore method');
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
      // showSnackBar(context, 'err in firestore method');
    }
  }

  //--------------------------------------------------------For Event----------------------------------------------------------------------------------

  _selectImageForEvent(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Event'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _fileforevent = file;
                    f = 1;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _fileforevent = file;
                    f = 1;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void eventImage(String uid, List<String> username, List<String> profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethodsForEvent().uploadPost(
        [_descriptionControllerforEvent.text],
        _fileforevent!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImageForPostAndEvent();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
          // showSnackBar(context, 'err in firestore method');
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
      // showSnackBar(context, 'err in firestore method');
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _descriptionControllerforEvent.dispose();
  }

  void clearImageForPostAndEvent() {
    setState(() {
      _fileforpost = null;
      _fileforevent = null;
      // _fileforpost.isEmpty;
      // _fileforevent.isEmpty;
    });
  }
//------------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (_fileforpost == null && _fileforevent == null)
        ? Column(
            children: <Widget>[
              const SizedBox(
                height: 250,
              ),
              Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.black,
                    size: 50,
                  ),
                  onPressed: () => _selectImageForPost(context),
                ),
              ),
              const Text(
                "Click to upload a Post",
                style: TextStyle(color: Colors.black54, fontSize: 25),
              ),
              IconButton(
                icon: const Icon(
                  Icons.upload,
                  color: Colors.black,
                  size: 50,
                ),
                onPressed: () => _selectImageForEvent(context),
              ),
              const Text(
                "Click to upload a Event",
                style: TextStyle(color: Colors.black54, fontSize: 25),
              ),
            ],
          )
        : (f == 0)
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: clearImageForPostAndEvent,
                  ),
                  title: const Text(
                    'Post to',
                    style: TextStyle(color: Colors.black),
                  ),
                  centerTitle: false,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => postImage(
                        userProvider.getUser.uid,
                        userProvider.getUser.username,
                        userProvider.getUser.photoUrl,
                        // userProfilePhotoUrl,

                      ),
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                // POST FORM
                body: ListView(children: [
                  Column(
                    children: <Widget>[
                      isLoading
                          ? const LinearProgressIndicator()
                          : const Padding(padding: EdgeInsets.only(top: 0.0)),
                      const Divider(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.7,
                        // height: 300.0,
                        // width: 300.0,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_fileforpost!),
                            )),
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              userProvider.getUser.photoUrl[0],
                              //   'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                  hintText: "Write a caption...",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                              maxLines: 8,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ]))
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: clearImageForPostAndEvent,
                  ),
                  title: const Text(
                    'Post to',
                    style: TextStyle(color: Colors.black),
                  ),
                  centerTitle: false,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => eventImage(
                        userProvider.getUser.uid,
                        userProvider.getUser.username,
                        userProvider.getUser.photoUrl,
                      ),
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                // POST FORM
                body: ListView(children: [
                  Column(
                    children: <Widget>[
                      isLoading
                          ? const LinearProgressIndicator()
                          : const Padding(padding: EdgeInsets.only(top: 0.0)),
                      const Divider(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.7,
                        // height: 300.0,
                        // width: 300.0,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_fileforevent!),
                            )),
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              userProvider.getUser.photoUrl[0],
                              //   'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              controller: _descriptionControllerforEvent,
                              decoration: const InputDecoration(
                                  hintText: "Write a caption...",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                              maxLines: 8,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ]),
              );
  }
}
