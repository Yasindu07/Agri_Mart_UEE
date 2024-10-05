import 'package:flutter/material.dart';

ThemeData colorMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF28A745),
      secondary: Color(0xFFDDFFD6),
      onPrimary: Color(0xFF78E28C),
      onSecondary: Color(0xFFEE7A6A),
      inversePrimary: Color(0xFFBDBDBD)),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Color(0xFF5C5B64),
        displayColor: Colors.black,
      ),
);
