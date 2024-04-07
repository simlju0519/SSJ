import 'package:ssj/classes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  Color fontColorAccent = InfoContainer.instance.fontColorAccent;


  Widget buildTextField(String hintText, IconData icon, bool isPassword, FocusNode focusNode, TextInputAction textInputAction) {
    // This function returns a TextField widget with the given parameters and styling
    // The function also updates the email and password variables when the text changes
    // The function also updates the focus node when the text changes

    return TextField(
      onChanged: (value) {
        setState(() {
          isPassword ? password = value : email = value;
        });
      },
      focusNode: focusNode,
      style: TextStyle(
        color: fontColorAccent,
        fontSize: 18,
        fontFamily: 'Roboto',
      ),
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
      textInputAction: textInputAction,
      onSubmitted: (value) {
        if (isPassword) {
          login();
        } else {
          FocusScope.of(context).requestFocus(passwordFocusNode);
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          icon,
          color: fontColorAccent,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: fontColorAccent,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }

  void login() {
    // This function is called when the user presses the login button
    // It checks if the email and password are valid
    // If they are, it logs the user in
    // If they are not, it shows an error message

    // Hashing the the password using SHA-512
    Digest sha512Password = sha512.convert(utf8.encode(password));
    
    d.log('Sending: Email: $email Password: $sha512Password');
  }

  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,

      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Image.asset('assets/ssjLogoWhite.png', height: 100, width: 100),
            SizedBox(height: 20),
            const Text(
              'Login with your account',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 10),

            Container(
              width: 300,
              child: buildTextField(
                'Email',
                Icons.email,
                false,
                emailFocusNode,
                TextInputAction.next,
              ),
            ),

            SizedBox(height: 5),

            Container(
              width: 300,
              child: buildTextField(
                'Password',
                Icons.lock,
                true,
                passwordFocusNode,
                TextInputAction.done,
              )
            ),

            SizedBox(height: 10),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: fontColorAccent,
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const NewAccountPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    )
                  );
              },
              child: const Text(
                'Don\'t have an account? Sign up here!',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


      floatingActionButton: Visibility(
        visible: email.isNotEmpty && password.isNotEmpty,
        maintainAnimation: true,
        maintainState: true,
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            opacity: email.isNotEmpty && password.isNotEmpty ? 1 : 0,
            child: FloatingActionButton.extended(
              heroTag: 'login',
              onPressed: () {
                login();
              },
              icon: Icon(
                Icons.login,
                size: 25,
              ),
              label: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ),
    );
  }
}


class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key});

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;
  late AnimationController animationController;
  late Animation<double> animation;
  Color fontColorAccent = InfoContainer.instance.fontColorAccent;

  Widget buildTextField(String hintText, IconData icon, bool isPassword, FocusNode focusNode, TextInputAction textInputAction, {bool isConfirmPassword = false}) {
    // This function returns a TextField widget with the given parameters and styling
    // The function also updates the email and password variables when the text changes
    // The function also updates the focus node when the text changes

    return TextField(
      onChanged: (value) {
        setState(() {
          if (isPassword) {
            isConfirmPassword ? confirmPassword = value : password = value;
          } else {
            email = value;
          }
        });
      },
      focusNode: focusNode,
      style: TextStyle(
        color: fontColorAccent,
        fontSize: 18,
        fontFamily: 'Roboto',
      ),
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
      textInputAction: textInputAction,
      onSubmitted: (value) {
        if (isPassword) {
          if (isConfirmPassword) {
            createAccount();
          } else {
            FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
          }
        } else {
          FocusScope.of(context).requestFocus(passwordFocusNode);
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          icon,
          color: fontColorAccent,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: fontColorAccent,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }

  void createAccount() {
    // This function is called when the user presses the create account button
    // It checks if the email and password are valid
    // If they are, it creates the account
    // If they are not, it shows an error message

    // Hashing the the password using SHA-512
    Digest sha512Password = sha512.convert(utf8.encode(password));
    
    d.log('Sending: Email: $email Password: $sha512Password');
  }

  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Image.asset('assets/ssjLogoWhite.png', height: 100, width: 100),
            SizedBox(height: 20),
            const Text(
              'Create a new account',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 10),

            Container(
              width: 300,
              child: buildTextField(
                'Email',
                Icons.email,
                false,
                emailFocusNode,
                TextInputAction.next,
              ),
            ),

            SizedBox(height: 5),

            Container(
              width: 300,
              child: buildTextField(
                'Password',
                Icons.lock,
                true,
                passwordFocusNode,
                TextInputAction.next,
              )
            ),

            SizedBox(height: 5),

            Container(
              width: 300,
              child: buildTextField(
                'Confirm Password',
                Icons.lock,
                true,
                confirmPasswordFocusNode,
                TextInputAction.done,
                isConfirmPassword: true,
              )
            ),

            SizedBox(height: 10),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: email.isNotEmpty && password == confirmPassword,
        maintainAnimation: true,
        maintainState: true,
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            opacity: email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty ? 1 : 0,
            child: FloatingActionButton.extended(
              heroTag: 'createAccount',
              onPressed: () {
                createAccount();
              },
              icon: Icon(
                Icons.login,
                size: 25,
              ),
              label: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ),
      ),
    );
  }
}