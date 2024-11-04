import 'package:flutter/material.dart';

Padding inputForm(
  Function(String?) validasi, {
  required TextEditingController controller,
  required String hintTxt,
  required String helperTxt,
  required IconData iconData,
  required Color hintColor,
  required Color textColor,
  bool password = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 10),
    child: SizedBox(
      width: 350,
      child: TextFormField(
        validator: (value) => validasi(value),
        controller: controller,
        obscureText: password,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hintTxt,
          hintStyle: TextStyle(color: hintColor),
          border: const OutlineInputBorder(),
          helperText: helperTxt,
          prefixIcon: Icon(iconData, color: hintColor),
        ),
      ),
    ),
  );
}
