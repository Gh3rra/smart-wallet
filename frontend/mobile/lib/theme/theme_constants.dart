import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              style: BorderStyle.solid, width: 2, color: Color(0xFF232323)))),
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Color(0xff909092),
      selectionHandleColor: Colors.black),
  fontFamily: "Poppins",
  colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white, //WHITE
      onPrimary: Color(0xff2C64E5), //BLUE
      secondary: Colors.white, //SECONDARY BACKGROUND
      onSecondary: Color(0xFFFF4848), //RED
      error: Colors.red,
      onError: Colors.red,
      surface: Color(0xffF7F7F7), //BACKGROUND
      onSurface: Color(0xFF232323), //TEXT
      tertiary: Color(0xffEDEFF3),
      onTertiary: Color(0xff909092),
      onTertiaryFixed: Color(0xff6B6B6B),
      surfaceContainer: Color(0xFFD1E4FF), //BUTTON BACKGROUND,
      onPrimaryContainer: Color.fromARGB(255, 219, 234, 255),
      shadow: Color(0x25000000) //SHADOW
      ),
  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Color(0xff909092),
      selectionHandleColor: Colors.white),
  fontFamily: "Poppins",
  colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black, //BLACK
      onPrimary: Color(0xff6197FF), //BLUE
      secondary: Color.fromARGB(255, 42, 42, 42), //SECONDARY BACKGROUND
      onSecondary: Color(0xffFF6161), //RED
      error: Colors.red,
      onError: Colors.red,
      surface: Color(0xFF000000), //BACKGROUND
      onSurface: Colors.white, //TEXT
      tertiary: Color(0xff373639),
      onTertiary: Color(0xff909092),
      onTertiaryFixed: Color(0xff6B6B6B),
      surfaceContainer: Color(0xff1A2330), //BUTTON BACKGROUND
      onPrimaryContainer: Color(0xFF283547),
      shadow: Colors.transparent),
  useMaterial3: true,
);







/*
const textFieldColor = Color(0xffEDEFF3);
const lightTextBox = Color(0xffEDEFF3);

const shadowColor = Color(0x25000000);
const blueShadowColor = Color(0x882C63E5);
const redShadowColor = Color(0x88FF6161);
const onTertiary = Color(0xff909092);
const onSecondary = Color(0xff4D4D4D); */



