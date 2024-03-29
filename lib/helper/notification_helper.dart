// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:grocery_delivery_boy/main.dart';
// import 'package:grocery_delivery_boy/provider/order_provider.dart';
// import 'package:grocery_delivery_boy/utill/app_constants.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// class NotificationHelper {

//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationsSettings);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       await Provider.of<OrderProvider>(Get.context!, listen: false).getAllOrders();
//     });
//   }

//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin? fln, bool data) async {
//     String? title;
//     String? body;
//     String? orderID;
//     String? image;
//     if(data) {
//       title = message.data['title'];
//       body = message.data['body'];
//       orderID = message.data['order_id'];
//       image = (message.data['image'] != null && message.data['image'].isNotEmpty)
//           ? message.data['image'].startsWith('http') ? message.data['image']
//           : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;
//     }else {
//       title = message.notification!.title;
//       body = message.notification!.body;
//       orderID = message.notification!.titleLocKey;
//       if(Platform.isAndroid) {
//         image = (message.notification!.android!.imageUrl != null && message.notification!.android!.imageUrl!.isNotEmpty)
//             ? message.notification!.android!.imageUrl!.startsWith('http') ? message.notification!.android!.imageUrl
//             : '${AppConstants.baseUrl}/storage/app/public/notification/${message.notification!.android!.imageUrl}' : null;
//       }else if(Platform.isIOS) {
//         image = (message.notification!.apple!.imageUrl != null && message.notification!.apple!.imageUrl!.isNotEmpty)
//             ? message.notification!.apple!.imageUrl!.startsWith('http') ? message.notification!.apple!.imageUrl
//             : '${AppConstants.baseUrl}/storage/app/public/notification/${message.notification!.apple!.imageUrl}' : null;
//       }
//     }

//     if(image != null && image.isNotEmpty) {
//       try{
//         await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, image, fln!);
//       }catch(e) {
//         await showBigTextNotification(title, body!, orderID, fln!);
//       }
//     }else {
//       await showBigTextNotification(title, body!, orderID, fln!);
//     }
//   }

//   static Future<void> showTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       AppConstants.appName, AppConstants.appName, channelDescription: AppConstants.appName, playSound: true,
//       importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }

//   static Future<void> showBigTextNotification(String? title, String body, String? orderID, FlutterLocalNotificationsPlugin fln) async {
//     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//       body, htmlFormatBigText: true,
//       contentTitle: title, htmlFormatContentTitle: true,
//     );
//     AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       AppConstants.appName, AppConstants.appName,
//       channelDescription: AppConstants.appName,
//       importance: Importance.max,
//       styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
//       sound: const RawResourceAndroidNotificationSound('notification'),
//     );
//     NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }

//   static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, String? orderID, String image, FlutterLocalNotificationsPlugin fln) async {
//     final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
//     final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
//       contentTitle: title, htmlFormatContentTitle: true,
//       summaryText: body, htmlFormatSummaryText: true,
//     );
//     final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       AppConstants.appName, AppConstants.appName, channelDescription: AppConstants.appName,
//       largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
//       styleInformation: bigPictureStyleInformation, importance: Importance.max,
//       sound: const RawResourceAndroidNotificationSound('notification'),
//     );
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }

//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }

// }

// Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
//   debugPrint("onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
//   // var androidInitialize = const AndroidInitializationSettings('notification_icon');
//   // var iOSInitialize = const IOSInitializationSettings();
//   // var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//   // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
//   // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grocery_delivery_boy/main.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';

import '../utill/navigation_service.dart';
import '../utill/route_arugment.dart';
import '../view/screens/chat/chat_screen.dart';
import '../view/screens/home/home_screen.dart';
import '../view/screens/order/order_details_screen.dart';
import '../view/screens/order/order_history_screen.dart';

class LocalNotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: handelNotificationPress,
        onDidReceiveBackgroundNotificationResponse: handelNotificationPress);
  }

  static AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'com.u6amtech.flutterGrocery', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    priority: Priority.max,
  );

  static void handelNotificationPress(NotificationResponse details) {
    final Map data = convertPayload(details.payload!);

    print('handelNotificationPress: ${data['conversation_id']}');
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => HomeScreen(
        orderid: data['order_id'],
      ),
    ));
  }

  static Map convertPayload(String payload) {
    final String payload0 = payload.substring(1, payload.length - 1);
    List<String> split = [];
    payload0.split(",").forEach((String s) => split.addAll(s.split(":")));
    Map mapped = {};
    for (int i = 0; i < split.length + 1; i++) {
      if (i % 2 == 1) {
        mapped.addAll({split[i - 1].trim().toString(): split[i].trim()});
      }
    }
    return mapped;
  }

  direct(
    context,
  ) {}
}
