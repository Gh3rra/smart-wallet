import 'package:flutter/material.dart';

showCustomSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    
      content: Text(
    content,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
  )));
}
