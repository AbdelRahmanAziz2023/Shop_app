import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/AuthProvider.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = 'AuthScreen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(100, 140, 255, 1).withOpacity(0.3),
                  const Color.fromRGBO(255, 190, 100, 1).withOpacity(0.8),
                ],
                stops: const [0, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 100),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.brown,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 2))
                          ]),
                      child: const Text(
                        'My Shop',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Anton',
                            fontSize: 50),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: screenSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey();
  AuthMode authMode = AuthMode.Login;
  Map<String, String> authMap = {
    'email': '',
    'password': '',
  };
  var isLoading = false;
  final passwordController = TextEditingController();
  late AnimationController controller;
  late Animation<Offset> slideAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    slideAnimation = Tween<Offset>(
        begin: const Offset(0, -0.15), end: const Offset(0, 0))
        .animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    try {
      if (authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(authMap['email']!, authMap['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(authMap['email']!, authMap['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEEK_PASSWORD')) {
        errorMessage = 'This password is weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = 'Couldnot authenticate. Please try again later.';
      showErrorDialog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  void switchAuthMode() {
    if (authMode == AuthMode.Login) {
      setState(() {
        authMode = AuthMode.SignUp;
      });
      controller.forward();
    } else {
      setState(() {
        authMode = AuthMode.Login;
      });
      controller.reverse();
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: authMode == AuthMode.SignUp ? 320 : 260,
        constraints:
        BoxConstraints(minHeight: authMode == AuthMode.SignUp ? 320 : 260),
        width: screenSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    authMap['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    authMap['password'] = value!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: TextFormField(
                        enabled: authMode == AuthMode.SignUp,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: authMode == AuthMode.SignUp
                            ? (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: submit,
                    child: Text(
                      authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                TextButton(
                  onPressed: switchAuthMode,
                  child: Text(
                    '${authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}