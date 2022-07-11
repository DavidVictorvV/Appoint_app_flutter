import 'package:flutter/material.dart';

import 'auth_pages/login/logIn_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginWidget(onClickedSignUp: toggle)
        : Center(child: Text("SignUp"));
    // : SignUpWidget(onClickedSignUp: toggle);
  }

  void toggle() => setState(() {
        //change the state of the var
        isLogin = !isLogin;
      });
}
