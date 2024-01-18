import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_delivery_boy/helper/notification_helper.dart';
import 'package:grocery_delivery_boy/provider/chat_provider.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/localization/app_localization.dart';
import 'package:grocery_delivery_boy/provider/auth_provider.dart';
import 'package:grocery_delivery_boy/provider/localization_provider.dart';
import 'package:grocery_delivery_boy/provider/language_provider.dart';
import 'package:grocery_delivery_boy/provider/order_provider.dart';
import 'package:grocery_delivery_boy/provider/profile_provider.dart';
import 'package:grocery_delivery_boy/provider/splash_provider.dart';
import 'package:grocery_delivery_boy/provider/theme_provider.dart';
import 'package:grocery_delivery_boy/provider/tracker_provider.dart';
import 'package:grocery_delivery_boy/theme/dark_theme.dart';
import 'package:grocery_delivery_boy/theme/light_theme.dart';
import 'package:grocery_delivery_boy/view/screens/home/home_screen.dart';
import 'package:grocery_delivery_boy/view/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'di_container.dart' as di;

FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? dd;
// SharedPreferences? sharedPreferences;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocalNotificationService.initialize(flnp).then((_) {
    debugPrint('setupPlugin: setup success');
  }).catchError((Object error) {
    debugPrint('Error: $error');
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    if (message.notification != null) {
      log("Message data payload: ${message.data}");
      flnp.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
              android:
                  LocalNotificationService.androidPlatformChannelSpecifics),
          payload: message.data.toString());

      // NavigationService.navigationKey.currentState!.pushNamed(
      //     ChatScreen.routeName,
      //     arguments: RouteArgument(param: message.data['order_id']));
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TrackerProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locals,
      home: const SplashScreen(),
    );
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  flnp.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
          android: LocalNotificationService.androidPlatformChannelSpecifics),
      payload: message.data.toString());
  print("Handling a background message: ${message.messageId}");
  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => HomeScreen(
      orderid: message.data['order_id'],
    ),
  ));
}

void _handleMessage(RemoteMessage message) {
  // navigatorKey.currentState?.push(MaterialPageRoute(
  //   builder: (context) => HomeScreen(
  //     orderid: message.data['order_id'],
  //   ),
  // )
  // );
  // navigatorKey.currentState!.push(MaterialPageRoute(
  //   builder: (context) => OrderHistoryScreen(),
  // ));
  // print(message.data['order_id']);
  // NavigationService.navigationKey.currentState!.pushNamed(ChatScreen.routeName,
  //     arguments: RouteArgument(param: message.data['order_id']));

  // Navigator.of(context).push(MaterialPageRoute(
  //     builder: (_) => ChatScreen()));
}
