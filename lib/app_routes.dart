import 'package:advaithaunnathi/prime_screens/prime_login_screen.dart';
import 'package:advaithaunnathi/prime_screens/prime_registration_screen.dart';
import 'package:get/get.dart';

import 'model/prime_member_model.dart';
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
    name: "/referral/:${primeMOs.refMemberId}",
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
