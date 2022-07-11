import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  State<UserName> createState() => ListPageState();
}

class ListPageState extends State<UserName> {
  String userId = "";
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future getDocId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              if (document.reference.id == uid) {
                userId = document.reference.id;
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDocId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: users.doc(userId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Text('${data['username']}');
                    }
                    return const Text('Loading...');
                  },
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
