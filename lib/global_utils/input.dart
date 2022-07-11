// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class MyInput extends StatefulWidget {
  final String label, hint;
  final IconData icon;
  final bool nr, last;
  final TextEditingController myController;
  final TextEditingController controller2;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return myController.text;
  }

  MyInput(this.label, this.hint, this.icon, this.myController, this.controller2,
      {this.nr = false, this.last = false});

  @override
  State<MyInput> createState() {
    return _MyInputState(label, hint, icon, myController, controller2,
        nr: nr, last: last);
  }
}

class _MyInputState extends State<MyInput> {
  // Iterable<Contact> _contacts;
  final String label, hint;
  final IconData icon;
  final bool nr, last;
  OverlayEntry? entry;
  final focusNode = FocusNode();
  final layerLink = LayerLink();
  final TextEditingController myController;
  final TextEditingController controller2;

  Iterable<Contact> _contacts = [];
  var _contactsL = [];

  Future<void> getContacts() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      await Permission.contacts.request();
    }
    status = await Permission.contacts.status;
    if (status.isGranted) {
      final Iterable<Contact> contacts = await FastContacts.allContacts;

      //We already have permissions for contact when we get to this page, so we
      // are now just retrieving it
      setState(() {
        _contacts = contacts;
      });
      print("Loaded contacts");
    }
  }

  TextEditingController getController() {
    return myController;
  }

  _MyInputState(
      this.label, this.hint, this.icon, this.myController, this.controller2,
      {this.nr = false, this.last = false});

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return myController.text;
  }

  @override
  void initState() {
    getContacts();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });

    super.initState();
  }

  void showOverlay() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - size.width / 8,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(size.width / 10, size.height),
          child: buildOverlay(),
        ),
      ),
    );

    overlay.insert(entry!);
  }

  hideOverlay() {
    entry?.remove();
    entry = null;
  }

  buildOverlay() {
    if (_contacts.length == 0 || _contacts == null) {
      return;
    }
    return Material(
      elevation: 8,
      child: SingleChildScrollView(
        child: Column(children: [
          ...(_contactsL as List).map((contact) {
            var phone = contact['phone'].toString();
            var name = contact['name'].toString();
            return ListTile(
              title: Text(!nr ? name : phone),
              subtitle: Text(!nr ? phone : name),
              onTap: () {
                myController.text = !nr ? name : phone;
                controller2.text = nr ? name : phone;
                hideOverlay();
                focusNode.unfocus();
              },
            );
          }).toList(),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CompositedTransformTarget(
        link: layerLink,
        child: TextFormField(
            focusNode: focusNode,
            controller: myController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: <String>(val) {
              if (val == null || val == "") return;
              setState(() {
                _contactsL = [];
              });
              for (var contact in _contacts) {
                var contName = contact.displayName;
                var phones = contact.phones[0];
                if (contName
                        .toLowerCase()
                        .startsWith(val.toString().toLowerCase()) ||
                    phones.startsWith(val.toString())) {
                  setState(() {
                    _contactsL.add({"name": contName, "phone": phones});
                  });
                }
              }
            },
            textInputAction: last ? TextInputAction.done : TextInputAction.next,
            keyboardType: nr ? TextInputType.phone : TextInputType.name,
            autofillHints: const [
              AutofillHints.telephoneNumberNational,
              AutofillHints.name
            ],
            inputFormatters: nr
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ]
                : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: label,
                hintText: hint,
                icon: Icon(icon))),
      ),
    );
  }
}
