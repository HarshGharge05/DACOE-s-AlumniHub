import 'package:flutter/material.dart';


class TextFieldInputForProf extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInputForProf(
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

          // suffixIcon: PopupMenuButton<String>(
          //   icon: Icon(Icons.arrow_drop_down),
          //   itemBuilder: (BuildContext context){
          //      return suggestions.map((String suggestion) {
          //        return PopupMenuItem<String>(
          //          value: suggestion,
          //          child: Text(suggestion),
          //        )
          //      }
          //   },
          // ),
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
