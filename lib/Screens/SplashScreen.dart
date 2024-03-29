import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

//cashing images to avoid freezing
  @override
  void didChangeDependencies() {
    precacheImage(AssetImage('assets/Images/Hero_Maker_Logo.png'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double HEIGHT = MediaQuery.of(context).size.height;
    double WIDTH = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          //Radial gradiant effect
            gradient: RadialGradient(
          center: Alignment.center,
          focalRadius: 1,
          radius: 1,
          colors: [
            Color(0XFF2E6994),
            Color(0XFF080e4f),
          ],
        )),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Spacer(
              flex: 7,
            ),
            //Animating the logo
          Image.asset(
                    'assets/Images/Hero_Maker_Logo.png',
                    height: HEIGHT * 0.17,
                  ),
          
            Spacer(
              flex: 6,
            ),
            Text(
              'Making you a hero...',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                    fontStyle: GoogleFonts.poppins().fontStyle,
                  ),
              textAlign: TextAlign.center,
            ),
            Spacer(
              flex: 1,
            ),
          ]),
        ),
      ),
    );
  }
}
