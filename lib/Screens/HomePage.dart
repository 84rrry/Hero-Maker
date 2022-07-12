// ignore_for_file: prefer_if_null_operators, body_might_complete_normally_nullable

import 'dart:math';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habbits_tracker/Model/habbit.dart';
import 'package:habbits_tracker/Components/Habbit%20Tile.dart';
import 'package:habbits_tracker/Screens/SplashScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Hive Db/Boxes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//function to provide greetings
String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 16) {
    return 'Good Afternoon';
  }
  if (hour < 20) {
    return 'Good evening';
  }
  return 'Peaceful Night';
}

//getting the current time
DateTime now = DateTime.now();
String formattedDate = DateFormat('EEE d MMM').format(now);

class _HomePageState extends State<HomePage> {
  //Text controller for habbit name
  TextEditingController habbitNameController = TextEditingController();
  //Text controller for habbit time goal
  TextEditingController timeGoalController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //List of used images backgrounds
  List<String> images = [
    'assets/Images/Background1.jpg',
    'assets/Images/Background2.jpg',
    'assets/Images/Background3.jpg',
    'assets/Images/Background4.jpg',
    'assets/Images/Background5.jpg',
    'assets/Images/Background6.jpg',
    'assets/Images/Background7.jpg',
    'assets/Images/Background8.jpg',
    'assets/Images/Background9.jpg',
  ];

  late Random randomImage;
  late int r;
  late AssetImage currentImage;
  PaletteColor? currentPalette = PaletteColor(Colors.grey, 2);
  late Future<PaletteColor?> _future;

  //function to choose a random image from the list of backgrounds
  AssetImage img() {
    int min = 0;
    int max = images.length - 1;
    randomImage = Random();
    r = min + randomImage.nextInt(max - min);
    String image_name = images[r];
    print(image_name);
    return AssetImage(image_name);
  }

//function to request permissions from the user
  Future<void> requestPermissons(BuildContext context) async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await [
                    Permission.ignoreBatteryOptimizations,
                  ].request();
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                },
                child: Text(
                  'Allow',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

//Function  to extract a color from an image
  Future<PaletteColor?> _updatePalettes(image) async {
    await Future.delayed(Duration(seconds: 2));
    print('started palette');
    PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      image,
      size: Size(400, 200),
    );
    print('finished palette');
    return generator.lightMutedColor != null
        ? generator.lightMutedColor
        : (generator.darkMutedColor != null
            ? generator.darkMutedColor
            : PaletteColor(Colors.grey, 2));
  }

//Function to play alarm when a habbit is completed
  void playAlarm() {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.alarm,
      looping: true,
      volume: 1,
    );
  }

//Function to stop the alarm
  void stopAlarm() {
    FlutterRingtonePlayer.stop();
  }

//Function to add a habbit
  Future? addHabbit(String habbitname, int goaltime) {
    final habbit = Habbit(
      habbitname,
      goaltime,
    );
    final box = Boxes.getHabbits();
    box.add(habbit);
  }

  @override
  void dispose() {
    Hive.close();
    habbitNameController.dispose();
    timeGoalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //loading random image
    currentImage = img();
    //extracting dominant color
    _future = _updatePalettes(currentImage);
    //listening for notifications
    AwesomeNotifications().createdStream.listen((notification) {
      playAlarm();
    });
    AwesomeNotifications().actionStream.listen((event) {
      stopAlarm();
    });
  }

  @override
  void didChangeDependencies() {
    //precashing images to avoid freezing
    precacheImage(currentImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //fetshing the height of the device
    var HEIGHT = MediaQuery.of(context).size.height;
    //fetshing the Width of the device
    var WIDTH = MediaQuery.of(context).size.width;
    return FutureBuilder(
      builder: (context, snapshot) {
        //when connection complete
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            currentPalette = snapshot.data as PaletteColor;
            return Scaffold(
              extendBodyBehindAppBar: true,
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: currentImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ValueListenableBuilder<Box<Habbit>>(
                    valueListenable: Boxes.getHabbits().listenable(),
                    builder: (context, box, _) {
                      final List habbitList =
                          box.values.toList().cast<Habbit>();
                      return CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            actions: [
                              IconButton(
                                  onPressed: () =>
                                      print(habbitList[0].habbitCompleted),
                                  icon: Icon(Icons.print))
                            ],
                            // Provide a title.
                            title: Text(
                              greeting(),
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: Colors.white),
                            ),

                            floating: true,
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: Text(
                                formattedDate,
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          box.values.toList().length == 0
                              ? SliverToBoxAdapter(
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: HEIGHT * 0.02,
                                      horizontal: WIDTH * 0.1,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          color: currentPalette!.color
                                              .withOpacity(0.5),
                                          padding: EdgeInsets.only(
                                            bottom: HEIGHT * 0.02,
                                          ),
                                          child: Column(
                                            children: [
                                              Lottie.asset(
                                                  'assets/Animations/you dead.zip',
                                                  height: HEIGHT * 0.5),
                                              Text(
                                                'Add Habbits or face the consequences!',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      fontSize: 20,
                                                      color: currentPalette!
                                                          .bodyTextColor,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => HabbitTile(
                                      key: ValueKey(
                                        habbitList[index].habbitName,
                                      ),
                                      habbit: habbitList[index],
                                      tileColor: currentPalette,
                                    ),
                                    childCount: habbitList.length,
                                  ),
                                ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: currentPalette!.color,
                onPressed: () async {
                  //asking for permissions
                  await requestPermissons(context);
                  //dialogue box to provide information about the added habbit
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: SingleChildScrollView(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: AlertDialog(
                              backgroundColor:
                                  currentPalette!.color.withOpacity(0.8),
                              title: Text(
                                'Add a habbit',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 20,
                                        color: currentPalette!.bodyTextColor),
                              ),
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      style: TextStyle(
                                          color: currentPalette!.bodyTextColor),
                                      cursorWidth: 1,
                                      cursorColor:
                                          currentPalette!.titleTextColor,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field can\'t be empty';
                                        }
                                        return null;
                                      },
                                      controller: habbitNameController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            color:
                                                currentPalette!.titleTextColor),
                                        prefixIcon: Icon(
                                          Icons.diamond_outlined,
                                          color: currentPalette!.bodyTextColor,
                                        ),
                                        labelText: 'Habbit',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color:
                                                currentPalette!.bodyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      style: TextStyle(
                                          color: currentPalette!.bodyTextColor),
                                      cursorWidth: 1,
                                      cursorColor:
                                          currentPalette!.titleTextColor,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field can\'t be empty';
                                        }
                                        return null;
                                      },
                                      controller: timeGoalController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            color:
                                                currentPalette!.titleTextColor),
                                        prefixIcon: Icon(
                                          Icons.timer_outlined,
                                          color: currentPalette!.bodyTextColor,
                                        ),
                                        labelText: 'Time Goal',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color:
                                                currentPalette!.titleTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      //showing a message to the user that ahabbit was created
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Creating Habbit!'),
                                        ),
                                      );
                                      //adding the habbit
                                      await addHabbit(habbitNameController.text,
                                          int.parse(timeGoalController.text));

                                      habbitNameController.clear();
                                      timeGoalController.clear();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: currentPalette!.bodyTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                //a button to close the alert dialogue 
                                TextButton(
                                  onPressed: () {
                                    habbitNameController.clear();
                                    timeGoalController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close',
                                      style: TextStyle(
                                        color: currentPalette!.titleTextColor,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.add,
                  color: currentPalette!.bodyTextColor,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        }
        return const SplashScreen();
      },
      future: _future,
    );
  }
}
