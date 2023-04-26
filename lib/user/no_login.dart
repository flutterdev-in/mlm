import 'package:advaithaunnathi/user/phone_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../custom widgets/text_widget.dart';

class NoLoginPage extends StatelessWidget {
  const NoLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextW("Account", is_heading: true, is_bold: true),
              const TextW("Log in to get exclusive offers"),
              GFButton(
                onPressed: () async {
                  Get.to(() => const PhoneAuthPage());
                },
                child: const TextW("Log In", is_bold: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
