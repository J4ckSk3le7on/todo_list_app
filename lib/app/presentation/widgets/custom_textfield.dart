import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;

  const CustomTextfield({
    super.key,
    required this.title,
    required this.textEditingController
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: title
      ),
      validator: (value) {
        if (value != null) {
          if (value.isNotEmpty) {
            return null;
          } else {
            return "This field should not be empty";
          }
        } else {
          return null;
        }
      },
    );
  }

}
