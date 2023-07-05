import 'package:flutter/material.dart';

Widget textEdit(validator, TextEditingController controller, keyboardType,
    String hintText, Icon icon, node, ontap) {
  return TextFormField(
    focusNode: node,
    onFieldSubmitted: (_) => ontap(_),
    obscureText: keyboardType == TextInputType.visiblePassword,
    validator: validator,
    controller: controller,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white, fontSize: 23),
    decoration: InputDecoration(hintText: hintText, prefixIcon: icon),
  );
}
