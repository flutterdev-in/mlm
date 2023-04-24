import 'package:advaithaunnathi/prime_screens/prime_login_screen.dart';
import 'package:advaithaunnathi/prime_screens/prime_registration_screen.dart';
import 'package:get/get.dart';

// import 'model/prime_member_model.dart';
import 'bottom_navigator.dart';
import 'model/prime_member_model.dart';

final appRoutes = [
  GetPage(
    name: "/",
    page: () {
      return
          //  const ConvertPrimeMembers();

          // const PrimeLoginScreen();
          // const PrimeRegistrationScreen();
          const BottomBarWithBody();
    },
  ),
  GetPage(
    name:
        // "/referral",
        "/referral/:${primeMOs.refMemberId}",
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
