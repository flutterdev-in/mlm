import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/prime_screens/prime_login_screen.dart';
import 'package:advaithaunnathi/prime_screens/prime_registration_screen.dart';
import 'package:get/get.dart';

import 'shopping/shopping_screen_home_page.dart';

final appRoutes = [
  GetPage(
    name: "/",
    page: () {
      return
          //  const ConvertPrimeMembers();

          // const PrimeLoginScreen();
          // const PrimeRegistrationScreen();
          const ShoppingScreenHomePage();
    },
  ),
  GetPage(
    name: "/referral/:${userMOs.refMemberId}",
    page: () {
      return const PrimeRegistrationScreen();
    },
  ),
  GetPage(
    name: "/prime",
    page: () {
      return const PrimeLoginScreen();
    },
  ),
];
