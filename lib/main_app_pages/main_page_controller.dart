import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../global_utils/get_curent_username.dart';
import 'add_client.dart';

class MainPage extends StatefulWidget {
  bool darkM;
  Function(bool) callback;

  MainPage(this.darkM, this.callback, {Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState(darkM, callback);
}

class _MainPageState extends State<MainPage> {
  var page = 0;
  bool isSwitched = false;
  bool darkM;
  Function(bool) callback;
  _MainPageState(this.darkM, this.callback);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 80.0,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.all(15.0),
                child: const Text('Appoint App'),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  const Text("Dark"),
                  Switch(
                    value: darkM,
                    onChanged: (value) {
                      callback(value);
                    },
                  ),
                  const Text("Ligth"),
                ],
              ),
            ),
            ListTile(
              title: const Text('Add client'),
              onTap: () {
                setState(() {
                  page = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Client list'),
              onTap: () {
                setState(() {
                  page = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: const [
            UserName(),
            SizedBox(
              width: 40,
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      // body: page == 0 ? AddUser() : UserList(),
      body: page == 0
          ? AddUser()
          : const Center(
              child: Text("User list"),
            ),
    );
  }
}
