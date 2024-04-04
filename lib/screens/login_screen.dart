import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alumniapp/resources/auth_methods.dart';
import 'package:alumniapp/responsive/mobile_screen_layout.dart';
import 'package:alumniapp/responsive/responsive_layout.dart';
import 'package:alumniapp/responsive/web_screen_layout.dart';
import 'package:alumniapp/screens/RegisterPage_screen.dart';
import 'package:alumniapp/utils/global_variable.dart';
import 'package:alumniapp/utils/utils.dart';
import 'package:alumniapp/widgets/text_field_input.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
          const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
      //
    } else {
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterScreenPage(),
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
        body: ListView(
          children: <Widget>[
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Flexible(child: Container(), flex: 2),
                    const SizedBox(
                      height: 40,
                    ),
                    const Icon(
                      Icons.lock,
                      color: Colors.black,
                      size: 80,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                        'Welcome back to DACOE!',
                        style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.w500),
                      ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(height: 25),
                    ),
                    TextFieldInput(
                      hintText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      style: TextStyle(
                          color: Colors.green,
                      ),

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
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: loginUser,
                      child: Container(
                        child: _isLoading
                            ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
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
                    Divider(height: 60,endIndent: 50, indent: 50,color: Colors.black,),
                    // Flexible(child: Container(), flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "Not a member?",
                            style: TextStyle(
                                color: Colors.grey,
                              fontSize: 20
                            ),),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: navigateToRegister,
                          child: Container(
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
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
          ],
        ),
      ),
    );
  }
}