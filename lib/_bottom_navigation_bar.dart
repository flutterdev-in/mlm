import 'package:advaithaunnathi/cart/cart_screen.dart';
import 'package:advaithaunnathi/dart/colors.dart';
import 'package:advaithaunnathi/gates.dart';
import 'package:advaithaunnathi/model/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'shopping/shopping_screen_home_page.dart';
import 'package:badges/badges.dart';

Rx<int> bottomBarindex = 0.obs;
PersistentTabController bottomNavController = PersistentTabController();

class BottomBarWithBody extends StatefulWidget {
  const BottomBarWithBody({Key? key}) : super(key: key);

  @override
  State<BottomBarWithBody> createState() => _BottomBarWithBodyState();
}

class _BottomBarWithBodyState extends State<BottomBarWithBody> {
  @override
  void initState() {
  
    super.initState();
  }
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
          icon: cartBadge(),
          
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

  Widget cartBadge(){
    var cartIcon = const Icon(MdiIcons.cart);

    return  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: cartMOS.authUserCartCR.limit(6).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty){
          if (snapshot.data!.docs.length > 5){
            return Badge(
            badgeContent: const Text("5+"),
            child: cartIcon);
            
          }else{
            return Badge(
            badgeContent: Text(snapshot.data!.docs.length.toString()),
            child: cartIcon)
            ;
          }
        }
        return cartIcon;
        
      }
    );
    
  }
}
