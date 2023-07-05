import 'package:admindukanv1/constant.dart';
import 'package:flutter/material.dart';

Widget animatedButtonUI(String text, ontop) {
  return GestureDetector(
    onTap: ontop,
    child: Container(
      height: 60,
      width: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: login_bg,
          ),
        ),
      ),
    ),
  );
}

Widget textButton(String text, ontop) {
  return GestureDetector(
      onTap: ontop,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
      ));
}
