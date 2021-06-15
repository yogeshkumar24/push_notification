import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

    var andoridInitSetting = AndroidInitializationSettings('app_icon');
    var iosInitSetting  =IOSInitializationSettings();

    var initSetting  = InitializationSettings(android: andoridInitSetting,iOS: iosInitSetting);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initSetting,);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '123',
      'NotifyDemo',
      'your other channel description',
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,);
    await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics);
    print("show imahe");
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late FirebaseMessaging messaging;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
      print("here is yout token ${value}");
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message received");
      _showNotificationCustomSound(event.data["title"],event.data["body"],event.data["image"]);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Future<void> _showNotificationCustomSound(title,body,image) async {
    var andoridInitSetting = AndroidInitializationSettings('app_icon');
    var iosInitSetting  =IOSInitializationSettings();

    var initSetting  = InitializationSettings(android: andoridInitSetting,iOS: iosInitSetting);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initSetting,);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '123',
      'NotifyDemo',
      'your other channel description',
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,);
    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,);
  }



}
