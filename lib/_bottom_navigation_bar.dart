import 'package:advaithaunnathi/cart/cart_screen.dart';
import 'package:advaithaunnathi/dart/colors.dart';
import 'package:advaithaunnathi/gates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'shopping/shopping_screen_home_page.dart';

Rx<int> bottomBarindex = 0.obs;
PersistentTabController bottomNavController = PersistentTabController();

class BottomBarWithBody extends StatelessWidget {
  const BottomBarWithBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bottomNavController.index = boxIndexes.get(boxKeyNames.bottomBarindex) ?? 0;
    // bottomBarindex.value = boxIndexes.get(boxKeyNames.bottomBarindex) ?? 0;
    if (bottomNavController.index == 4) {
      bottomNavController.index = 0;
    }
    return PersistentTabView(
      context,
      controller: bottomNavController,
      onItemSelected: (index) async {
        bottomBarindex.value = index;
      },
      navBarStyle: NavBarStyle.simple,
      screens: const [
        ShoppingScreenHomePage(),
        CartScreen(),
        AccountGate(false),
        AccountGate(true),
      ],
      decoration: NavBarDecoration(
          border: Border.all(color: Colors.black26, width: 0.45)),
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.home),
          inactiveIcon: const Icon(MdiIcons.homeOutline),
          title: ("Shopping"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.cart),
          inactiveIcon: const Icon(MdiIcons.cartOutline),
          title: ("Cart"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.account),
          inactiveIcon: const Icon(MdiIcons.accountOutline),
          title: ("Account"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.accountGroup),
          inactiveIcon: const Icon(MdiIcons.accountGroupOutline),
          title: ("Prime"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ],
    );
  }
}
