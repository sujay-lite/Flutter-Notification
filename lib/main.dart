import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'notifcation_controller.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "daily_checkin_group",
        channelKey: "daily_checkin_channel",
        channelName: "basic_notification",
        channelDescription: "Sending Daily checkin notification")
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "daily_checkin_group",
      channelGroupName: "Daily Check-In Group",
    )
  ]);

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Notification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var today = DateTime.now();

  void scheduleNotification() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    print("❤️ Scheduling notification ${DateTime.now()}");
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "daily_checkin_channel",
          title: 'Just in time!',
          body: 'Schedule to shows at ${DateTime.now()}',
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: 'asset://assets/images/delivery.jpeg',
          payload: {'uuid': 'uuid-test'},
        ),

        ///SCHEDULING NOTIFICATION AT GIVEN DATE and/or TIME (CAN BE SET TO REPEAT)
        schedule: NotificationCalendar(
            hour: 0, minute: 56, timeZone: localTimeZone, repeats: true));

    /// WORKING CODE FOR SCHEDULING NOTIFICATION AT FIXED REGULAR INTERVALS
    // schedule: NotificationInterval(
    //     interval: 600, timeZone: localTimeZone, repeats: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: scheduleNotification,
          child: const Text("Schedule Notification from now"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 1,
                  channelKey: "daily_checkin_channel",
                  title: "Daily Check-In Reminder",
                  body: "It is time to check in for today."));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.notification_add),
      ),
    );
  }
}
