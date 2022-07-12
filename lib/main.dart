import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habbits_tracker/Themes/Apptheme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Model/habbit.dart';
import 'Screens/HomePage.dart';
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      'resource://drawable/icon_notification',
      [
        NotificationChannel(
            channelKey: 'Habbit_Completed_channel',
            channelName: 'Habbit Completed notifications',
            channelDescription:
                'Notification channel for Alerting user the a habbit is completed',
            defaultColor: Color.fromARGB(255, 50, 96, 165),
            importance: NotificationImportance.High,
            playSound: false,
            enableVibration: true,
            ledColor: Colors.white)
      ],
      debug: true);

  await Hive.initFlutter();
  Hive.registerAdapter(HabbitAdapter());
  await Hive.openBox<Habbit>('Habbits');

  runApp(const HeroMaker());
}

class HeroMaker extends StatelessWidget {
  const HeroMaker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightAppTheme(),
      home: HomePage(),
    );
  }
}
