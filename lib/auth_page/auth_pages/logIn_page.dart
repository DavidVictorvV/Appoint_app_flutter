import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../global_utils/utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
              'Hey there, \n Welcome Back',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            //input for email
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    //check if email is correct type
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
                }
                return null;
              },
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          //show/hide password
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility))),
              obscureText: hidePassword,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              icon: const Icon(
                Icons.lock_open,
                size: 32,
              ),
              label: const Text("Sign In"),
              onPressed: signIn,
            ),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Center(
                        child: Text("Forgot Password Page"),
                      )
                  // const ForgotPasswordPage(),
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(fontSize: 17),
                    text: "No account?  ",
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: "Sign Up",
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

  Future signIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        //show snackbar if there is an error
        Utils.showSnackBar(e.message);
      }

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
