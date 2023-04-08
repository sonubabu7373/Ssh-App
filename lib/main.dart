import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'screens/home/home_screen.dart';
import 'utils/my_sroll_behaviour.dart';

//Sample Test client Login
const host = '137.184.170.205';
const port = 22;
const username = 'sonu';
const password = 'Sonu123#';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext ctx) {
    return ScreenUtilInit(
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
            ),
          ),
          scrollBehavior: MyScrollBehavior(),
          builder: BotToastInit(),
          home: const HomeScreen(),
        );
      },
    );
  }
}
