import 'dart:typed_data';
import 'package:alumniapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alumniapp/resources/auth_methods.dart';
import 'package:alumniapp/responsive/mobile_screen_layout.dart';
import 'package:alumniapp/responsive/responsive_layout.dart';
import 'package:alumniapp/responsive/web_screen_layout.dart';
import 'package:alumniapp/screens/login_screen.dart';
import 'package:alumniapp/utils/utils.dart';
import 'package:alumniapp/widgets/text_field_input.dart';

import 'dart:typed_data';
import 'package:http/http.dart' as http;


class RegisterScreenPage extends StatefulWidget {
  const RegisterScreenPage({super.key});

  @override
  State<RegisterScreenPage> createState() => _RegisterScreenPageState();
}

class _RegisterScreenPageState extends State<RegisterScreenPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  // final response =  http.get(Uri.parse('https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'));


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // _descriptionController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }




  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        description: _descriptionController.text,
        file: _image!
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
          // const ResponsiveLayout(
          //   mobileScreenLayout: MobileScreenLayout(),
          //   webScreenLayout: WebScreenLayout(),
          // ),
          SplashScreen()
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreenPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: ListView(children: <Widget>[
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Flexible(child:Container(),flex: 2),

                    // const Icon(
                    //   Icons.lock,
                    //   size: 80,
                    // ),
                    const SizedBox(
                      height: 40,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(_image!),
                        )
                            : const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 60,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo, color: Colors.black,),
                            // color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    const Text(
                      "Let's create an account for you",
                      style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w500),
                    ),

                    // const SizedBox(
                    //   height: 40,
                    // ),


                    SizedBox(height: 20),

                    TextFieldInput(
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
                      style : TextStyle(color: Colors.black),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 5,
                      ),
                    ),

                    TextFieldInput(
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      style: TextStyle(color: Colors.black),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 5,
                      ),
                    ),

                    TextFieldInput(
                      hintText: 'Password',
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      isPass: true,
                      style: TextStyle(color: Colors.black),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 5,
                      ),
                    ),

                    TextFieldInput(
                      hintText: 'About (ex. Student, Intern, SDE @)',
                      textInputType: TextInputType.text,
                      textEditingController: _descriptionController,
                      style: TextStyle(color: Colors.black),
                    ),

                    const SizedBox(height: 15),

                    InkWell(
                      onTap: signUpUser,
                      child: Container(
                        child: _isLoading
                            ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Register Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(52),
                              ),
                            ),
                            color: Colors.blue),
                      ),
                    ),

                    Divider(height: 40, endIndent: 50, indent: 50, color: Colors.black,),
                    //const SizedBox(height: 3),

                    // Flexible(child:Container(),flex: 2),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                              "Already have an account?",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 1,
                          ),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: navigateToLogin,
                          child: Container(
                            child: Text(
                              "Login now",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}