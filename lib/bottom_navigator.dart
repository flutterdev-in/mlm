import 'package:advaithaunnathi/shopping/shopping_screen_home_page.dart';
import 'package:advaithaunnathi/user/no_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'prime_screens/prime_page.dart';
import 'user/user_account_screen.dart';

//

class BottomBarWithBody extends StatefulWidget {
  const BottomBarWithBody({Key? key}) : super(key: key);

  @override
  State<BottomBarWithBody> createState() => _BottomBarWithBodyState();
}

class _BottomBarWithBodyState extends State<BottomBarWithBody> {
  @override
  void initState() {
    // FlutterNativeSplash.remove();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      // onItemSelected: onTabSelected,
      navBarStyle: NavBarStyle.style8,
      resizeToAvoidBottomInset: true,
      screens: [
        const ShoppingScreenHomePage(),
        const ShoppingScreenHomePage(),
        StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const UserAccountScreen();
              }
              return const NoLoginPage();
            }),
        StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const PrimePage();
              }

              return const NoLoginPage();
            }),
      ],
      decoration: NavBarDecoration(
          colorBehindNavBar: Colors.white,
          border: Border.all(color: Colors.black26, width: 0.45)),
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.home),
          inactiveIcon: const Icon(MdiIcons.homeOutline),
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
          title: "Home",
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.viewGrid),
          inactiveIcon: const Icon(MdiIcons.viewGridOutline),
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
          title: "Categories",
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.account),
          inactiveIcon: const Icon(MdiIcons.accountOutline),
          title: "Account",
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.accountGroup),
          inactiveIcon: const Icon(MdiIcons.accountGroupOutline),
          title: "Prime",
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
        ),
      ],
    );
  }

  // Future<void> onTabSelected(int index) async {

  // }
}


//

