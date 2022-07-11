// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var phone, name, week;
    final user = FirebaseAuth.instance.currentUser!;
    final myControllerName = TextEditingController();
    final myControllerPhone = TextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 30, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  // name = MyInput("Name", "David", Icons.person, myControllerName,
                  // myControllerPhone),
                  // phone = MyInput(
                  //   "Phone",
                  //   "07...",
                  //   Icons.phone_iphone,
                  //   myControllerPhone,
                  //   myControllerName,
                  //   nr: true,
                  //   last: true,
                  // ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: const [
                            Text(
                              "Duration",
                            ),
                            Text(
                              "(weeks):",
                            ),
                          ],
                        ),
                      ),
                      // week = WeekButton(),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        print(phone.toString());
                        primaryFocus!.unfocus();
                        var now = DateTime.now();

                        now = now.add(Duration(days: week.getWeeks() * 7));

                        var newD = DateTime(now.year, now.month, now.day);

                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String formatted = formatter.format(now);
                        print(formatted.toString());

                        FirebaseAuth auth = FirebaseAuth.instance;
                        String uid = auth.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .collection('clients')
                            .add({
                          'date': formatted.toString(),
                          'name': name.toString(),
                          "phone_number": phone.toString()
                        });

                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data...')),
                        );
                      }
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
