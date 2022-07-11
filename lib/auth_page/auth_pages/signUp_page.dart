import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../global_utils/utils.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignUpWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hidePassword2 = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordCController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            const FlutterLogo(
              size: 120,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Sign Up:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              //input for username
              controller: usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username can not be empty!';
                }
                return null;
              },
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(
              height: 4,
            ),
            TextFormField(
              //input for mail
              controller: emailController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)) {
                  return 'Please enter a valid mail!';
                }
                return null;
              },
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(
              height: 4,
            ),
            TextFormField(
              //input for password
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid password!';
                } else if (value.length < 6) {
                  return "Password should be at least 6 characters";
                }
                return null;
              },
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });

                        print(hidePassword);
                      },
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility))),
              obscureText: hidePassword,
            ),
            const SizedBox(
              height: 4,
            ),
            TextFormField(
              //input for password check
              controller: passwordCController,
              validator: (value) {
                if (value != passwordController.text.trim()) {
                  return 'Passwords do not match!';
                }
                return null;
              },
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword2 = !hidePassword2;
                        });

                        print(hidePassword);
                      },
                      icon: Icon(hidePassword2
                          ? Icons.visibility_off
                          : Icons.visibility))),
              obscureText: hidePassword2,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              icon: const Icon(
                Icons.arrow_forward,
                size: 25,
              ),
              label: const Text("Sign Up"),
              onPressed: signUp,
            ),
            const SizedBox(
              height: 24,
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(fontSize: 17),
                    text: "Already have an account?  ",
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: "Log in",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ))
                ]))
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      //send data to db
      addUserDetails();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future addUserDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "username": usernameController.text.trim(),
      "mail": emailController.text.trim(),
    });
  }
}
