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
  bool isLoading = false;
  int f = 0;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _descriptionControllerforEvent =
  TextEditingController();

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

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
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

  void eventImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethodsForEvent().uploadPost(
        _descriptionControllerforEvent.text,
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
    });
  }
//------------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade400,
        title: const Text(
          'Add Post/Event',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.cyan.shade50,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => _selectImageForPost(context),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "            Click to upload a Post",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectImageForEvent(context),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "             Click to upload an Event",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
          // Positioned(
          //   top: 0,
          //   // child: Icon(
          //   //   //Icons.arrow_downward_sharp,
          //   //   //color: Colors.black,
          //   //   //size: 50,
          //   // ),
          // ),
          // Positioned(
          //   bottom: 0,
          //   // child: Icon(
          //   //  // Icons.arrow_upward_sharp,
          //   //   //color: Colors.black,
          //   //  // size: 50,
          //   // ),
          // ),
        ],
      ),
    );
  }
}
