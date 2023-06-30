// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/langauge_translate.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    name: 'your_app_name',
    options: FirebaseOptions(
      apiKey: 'your_api_key',
      appId: 'your_app_id',
      messagingSenderId: 'your_sender_id',
      projectId: 'your_project_id',
    ),
  );
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ColorNotifire())],
    child: GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en_US', 'en_US'),
      title: 'GoEvent'.tr,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Gilroy"),
      home: const Directionality(
          textDirection: TextDirection.ltr, // set this property
          child: Spleshscreen()),
    ),
  ));
}
