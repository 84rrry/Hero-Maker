import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habbits_tracker/Model/habbit.dart';
import 'package:habbits_tracker/Services/utils.dart';

Future<void> createHabbitCompletedNotification(Habbit habbit) async {
  await AwesomeNotifications().createNotification(
    actionButtons: [
      NotificationActionButton(key: 'Stop', label: 'Stop',color: Colors.blue,)
    ],
    content: NotificationContent(
      id: Utils.createUniqueId(),
      channelKey: 'Habbit_Completed_channel',
      title:
          '${Emojis.award_trophy} Habbit Completed ${habbit.habbitCompleted}!',
      body: 'You completed ${habbit.habbitName}. ',
      autoDismissible: false,
      locked: true,
      color: Colors.blueAccent,
      // bigPicture: 'asset://assets/notification_map.png',
      notificationLayout: NotificationLayout.BigText,
    ),
  );
}