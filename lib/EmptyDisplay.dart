import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget empty_display() {
  return Column(
    children: [
      IconButton(
          onPressed: null,
          icon: Icon(Icons.add_card,
              color: Color.fromARGB(255, 202, 203, 208), size: 60)),
      Text(
        "Add NEW todolist through '+' icon",
        style:
            TextStyle(fontSize: 30, color: Color.fromARGB(255, 202, 203, 208)),
      )
    ],
  );
}
