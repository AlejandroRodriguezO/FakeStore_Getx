import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_getx/pages/controller/theme_controller.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Store Getx',
          theme: ThemeData(
            brightness: _.dark ? Brightness.dark : Brightness.light,
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
