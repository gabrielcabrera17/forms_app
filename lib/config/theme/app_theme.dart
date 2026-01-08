import 'package:flutter/material.dart';

class AppTheme {


  ThemeData getTheme(){
    const sendColor = Colors.deepPurple;
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: sendColor,
      listTileTheme: const ListTileThemeData(
        iconColor: sendColor
      )
    );
  }

}