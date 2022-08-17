import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '_bottom_navigation_bar.dart';
import 'dart/colors.dart';
import 'shopping/shopping_screen_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,

      navigatorKey: Get.key,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: primaryColor),
        primaryColor: Colors.deepPurple.shade800,
        primaryColorLight: Colors.deepPurple.shade800,
        // textTheme: Theme.of(context).textTheme.apply(),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // initialBinding: HomeBinding(),
      title: 'Advaita Unnathi',
      // initialRoute: "/",.
      // getPages: AppRoutes.routes,
      home: // const MyHomePage0(),
          // const BottomBarWithBody(),
      // const Company(),
      // const PrimeScreenHomePage(),
      const ShoppingScreenHomePage(),
    );
  }
}



