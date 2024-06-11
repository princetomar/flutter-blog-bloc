import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObsecureText;
  const AuthField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObsecureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecureText,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
    );
  }
}
