import 'package:flutter/material.dart';

class WeekButton extends StatefulWidget {
  List<bool> isSelected = [true, false];

  int getWeeks() {
    if (isSelected[0] == true) {
      return 2;
    } else
      return 4;
  }

  @override
  State<WeekButton> createState() => _WeekButtonState();
}

class _WeekButtonState extends State<WeekButton> {
  @override
  Widget build(BuildContext context) {
    var isSelected = widget.isSelected;
    return ToggleButtons(
      borderWidth: 2,
      onPressed: (int index) {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: isSelected,
      children: const <Widget>[Text("2 W"), Text("4 W")],
    );
  }
}
