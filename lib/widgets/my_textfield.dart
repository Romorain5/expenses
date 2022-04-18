import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController _controller;
  final Function _onSubmitted;
  final String _title;
  final bool _isOnlyNumbers;

  MyTextField(
    this._controller,
    this._onSubmitted,
    this._title,
    this._isOnlyNumbers,
  );

  isOnlyNumbersFunc() {
    if (_isOnlyNumbers) {
      return TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      );
    } else
      return;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30),
          ),
          labelText: _title,
          labelStyle: TextStyle(color: Colors.white38),
          fillColor: Color.fromARGB(255, 82, 88, 112),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20, 18, 18, 18)),
      controller: _controller,
      onSubmitted: _onSubmitted,
      keyboardType: isOnlyNumbersFunc(),

      //onChanged: (value) {
      //  titleInput = value;
      //},
    );
  }
}
