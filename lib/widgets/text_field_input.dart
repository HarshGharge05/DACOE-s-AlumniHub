import 'package:flutter/material.dart';

// class TextFieldInput extends StatelessWidget {
//   final TextEditingController textEditingController;
//   final bool isPass;
//   final String hintText;
//   final TextInputType textInputType;
//   const TextFieldInput({
//     Key? key,
//     required this.textEditingController,
//     this.isPass = false,
//     required this.hintText,
//     required this.textInputType,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final inputBorder = OutlineInputBorder(
//       borderSide: Divider.createBorderSide(context),
//     );
//
//     return TextField(
//       controller: textEditingController,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: inputBorder,
//         focusedBorder: inputBorder,
//         enabledBorder: inputBorder,
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       keyboardType: textInputType,
//       obscureText: isPass,
//     );
//   }
// }

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput(
      {super.key,
        required this.textEditingController,
        this.isPass = false,
        required this.hintText,
        required this.textInputType, });

  @override
  Widget build(BuildContext context) {
    final inputborder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(

          hintText: hintText,
          // border: inputborder,
          border: inputborder,
          // focusedBorder: inputborder,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          // enabledBorder: inputborder,

          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          filled: true,

          hintStyle: TextStyle(color: Colors.grey[500])),
      style: TextStyle(color: Colors.black),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
