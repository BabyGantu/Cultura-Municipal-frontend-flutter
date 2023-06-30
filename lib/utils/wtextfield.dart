import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Customtextfild3 {
  static Widget textField(
      controller, textcolor, hinttext, wid, type, no, align, readOnly) {
    return Container(
      color: Colors.transparent,
      height: 45,
      width: wid,
      child: TextField(
        controller: controller,
        keyboardType: type,
        readOnly: readOnly,
        inputFormatters: [LengthLimitingTextInputFormatter(no)],
        style: TextStyle(color: textcolor, fontSize: 13),
        textAlign: align,
        decoration: InputDecoration(
          labelText: hinttext,
          labelStyle: const TextStyle(color: Colors.grey),
          disabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff80818d), width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff5669FF), width: 1),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
