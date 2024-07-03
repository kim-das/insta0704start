import 'package:flutter/material.dart';

var theme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.grey,
    )
  ),


  appBarTheme: AppBarTheme(
    actionsIconTheme: IconThemeData(color: Colors.black),
    color:Colors.white,
    elevation: 1.0,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor:Colors.black,
  ),
  

);

class CustomImage extends StatelessWidget {
  const CustomImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
