import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData LightAppTheme() => ThemeData(
      primaryColor: Colors.grey[900],
      dividerColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.white),
      scaffoldBackgroundColor: Colors.grey[400],
      appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: Colors.grey[900],
          size: 30,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black.withOpacity(0.35),
          statusBarIconBrightness: Brightness.light,
        ),
        color: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(size: 15),
          unselectedItemColor: Colors.blueGrey),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white24,
        iconSize: 30,
        
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: GoogleFonts.roboto(textStyle:TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        ),
        
        bodyText2: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
