import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/prime_screens/_prime_gate.dart';
import 'package:advaithaunnathi/prime_screens/prime_login_screen.dart';
import 'package:advaithaunnathi/prime_screens/prime_registration_screen.dart';
import 'package:advaithaunnathi/shopping/shopping_screen_home_page.dart';
import 'package:get/get.dart';

import 'services/firebase.dart';

final appRoutes = [
  GetPage(
    name: "/",
    page: () {
      return const PrimeLoginScreen();
      // const PrimeRegistrationScreen();
      // const ShoppingScreenHomePage(null);
    },
  ),
  GetPage(
    name: "/referral/:${userMOs.refMemberId}",
    page: () {
      if (fireUser() != null) {
        return const PrimeGate(true);
      } else {
        return const ShoppingScreenHomePage(true);
      }
    },
  ),
];
