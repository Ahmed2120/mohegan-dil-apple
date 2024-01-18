import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/provider/auth_provider.dart';
import 'package:grocery_delivery_boy/provider/splash_provider.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/view/screens/auth/maintenance_screen.dart';
import 'package:grocery_delivery_boy/view/screens/chat/chat_screen.dart';
import 'package:grocery_delivery_boy/view/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_delivery_boy/view/screens/home/const.dart';
import 'package:grocery_delivery_boy/view/screens/language/choose_language_screen.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .maintenanceMode!) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const MaintenanceScreen()));
        } else {
          Timer(const Duration(seconds: 1), () async {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()));
            } else {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => const ChooseLanguageScreen()));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginScreen()));
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(Images.logo, width: 150)),
            const SizedBox(height: 20),
            //Text(AppConstants.appName, style: rubikBold.copyWith(fontSize: 30, color: Theme.of(context).primaryColor), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
