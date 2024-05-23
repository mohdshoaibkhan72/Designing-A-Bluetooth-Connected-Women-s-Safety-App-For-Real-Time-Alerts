import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_steps/push_notification/LocalNotificationService.dart';
import 'package:safe_steps/screens/user_type/UserType.dart';
import 'package:safe_steps/values.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  String? token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await Permission.bluetooth.request();
  // await Permission.bluetoothAdmin.request();
  runApp(MyApp(fcmToken: token,));
}

Future backgroundHandler(RemoteMessage msg) async {}

class MyApp extends StatefulWidget {
  MyApp({super.key, this.fcmToken});
  String? fcmToken;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {

    super.initState();

    // LocalNotificationService.initialize();

    // To initialise the sg
    FirebaseMessaging.instance.getInitialMessage().then((message) {

    });

    // To initialise when app is not terminated
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationService.display(message);
      }
    });

    // To handle when app is open in
    // user divide and heshe is using it
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("on message opened app");
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: UserType(fcm_token: widget.fcmToken,)
    );
  }
}