import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'auth_page/auth_controller.dart';
import 'global_utils/utils.dart';
import 'plugins/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool darkM = false;
  callback(dark) {
    //get the state of the page(day/nigth mode)
    setState(() {
      darkM = dark;
    });
    getStyle();
  }

  ColorScheme getStyle() {
    //get the color scheme from flutter based on the mode
    if (!darkM) {
      return ColorScheme.dark();
    } else {
      return ColorScheme.light();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          //app general styling
          colorScheme: getStyle(),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => const ColorScheme.dark().secondary),
          ))),
      home: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                //check if firebase loaded correctly
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //if connecting show loading circle
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  //if there is an error show error message
                  return const Center(
                    child: Text("Something went wrong!"),
                  );
                } else if (snapshot.hasData) {
                  //if firebase auth loaded and logged in show verify page
                  // return VerifyEmailPage(darkM, callback);
                  return Center(child: Text("Verify page"));
                } else {
                  //go to authentification controller
                  return AuthPage();
                }
              })),
    );
  }
}
