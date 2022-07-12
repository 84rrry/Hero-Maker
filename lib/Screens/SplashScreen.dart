import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';

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
      // backgroundColor: Color(0XFF0f0f0f),
      body: Container(
        // color: Colors.grey.withOpacity(0.7),
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          center: Alignment.center,
          focalRadius: 1,
          radius: 1,
          colors: [
            // Colors.grey,
            Color(0XFF2E6994),
            // Colors.black,
            Color(0XFF080e4f),
          ],
        )),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Spacer(flex: 7,),
            MirrorAnimation(
            builder: (context, child, double value) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi*value),
          
          child:Image.asset('assets/Images/Hero_Maker_Logo.png',height: HEIGHT * 0.2, ),
        );
      },
            duration: const Duration(milliseconds:1000 ),
      tween: Tween<double>(begin: 0, end: 1),
           ),
            
            Spacer(flex: 6,),
            Text(
              'Making you a hero...',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 18, color: Colors.white,fontStyle:  GoogleFonts.poppins().fontStyle,),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 1,),
          ]),
        ),
      ),
    );
  }
}
