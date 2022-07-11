import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../global_utils/utils.dart';
import '../../main_page.dart';

class VerifyEmailPage extends StatefulWidget {
  bool darkM;
  Function(bool) callback;
  VerifyEmailPage(this.darkM, this.callback, {Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() =>
      _VerifyEmailPageState(darkM, callback);
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  bool darkM;
  Function(bool) callback;

  _VerifyEmailPageState(this.darkM, this.callback);

  Timer? timer;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      //check if email has been verified
      timer = Timer.periodic(const Duration(seconds: 10), (_) {
        checkEmailVerified();
      });
    }
    super.initState();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? MainPage(darkM, callback)
        : Scaffold(
            appBar: AppBar(
              title: const Text("Verify Email"),
              actions: [
                GestureDetector(
                  onTap: () => FirebaseAuth.instance.signOut(),
                  child: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'A verification mail has been sent \n (Check spam)',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        maximumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(
                        Icons.email,
                        size: 32,
                      ),
                      label: const Text(
                        "Resent Mail",
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                    ),
                    ElevatedButton(
                      child: const Text("Log out!"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
