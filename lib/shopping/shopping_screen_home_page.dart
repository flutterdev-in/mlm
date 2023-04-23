import 'package:advaithaunnathi/custom%20widgets/auth_stream_builder.dart';
import 'package:advaithaunnathi/custom%20widgets/list_stream_docs_builder.dart';
import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/policies/policies_card.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/shopping/Home%20screen%20w/c_products_grid_list.dart';
import 'package:advaithaunnathi/shopping/z_cart/cart_screen.dart';
import 'package:advaithaunnathi/user/user_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../custom widgets/bottom_bar_login.dart';
import '../dart/colors.dart';
import '../dart/repeatFunctions.dart';
import '../services/fcm.dart';
import '../model/user_model.dart';

//
class ShoppingScreenHomePage extends StatefulWidget {
  const ShoppingScreenHomePage({Key? key}) : super(key: key);

  @override
  State<ShoppingScreenHomePage> createState() => _ShoppingScreenHomePageState();
}

class _ShoppingScreenHomePageState extends State<ShoppingScreenHomePage> {
  @override
  void initState() {
    FCMfunctions.setupInteractedMessage();
    FCMfunctions.onMessage();
    FCMfunctions.checkFCMtoken();
    userMOs.userInit();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("MyShop"),
              actions: [
                IconButton(
                  onPressed: () async {
                    await waitMilli(250);
                    Get.toNamed("/prime");
                  },
                  icon: const Icon(MdiIcons.alphaPCircleOutline),
                ),
                IconButton(
                  onPressed: () {
                    if (snapshot.hasData) {
                      Get.to(() => const UserAccountScreen());
                    } else {
                      bottomBarLogin();
                    }
                  },
                  icon: const Icon(MdiIcons.accountCircleOutline),
                ),
                IconButton(
                  onPressed: () async {
                    await waitMilli(200);
                    if (fireUser() != null) {
                      Get.to(() => const CartScreen());
                    } else {
                      bottomBarLogin();
                    }
                  },
                  icon: cartBadge(),
                ),
              ],
            ),
            body: ListView(
              children: const [
                SizedBox(height: 10),
                ProductsGridList(),
                SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(appUpdatedTime),
                ),
                SizedBox(height: 10),
                PoliciesPortion(),
              ],
            ),
          );
        });
  }

  Widget cartBadge() {
    var cartIcon = const Icon(MdiIcons.cart);
    return AuthStreamBuilder(
        unAuthW: cartIcon,
        builder: (user) {
          return StreamListDocsBuilder(
            loadingW: cartIcon,
            noResultsW: cartIcon,
            errorW: cartIcon,
            query: authUserCR.doc(user.uid).collection(cart),
            builder: (snaps) {
              if (snaps.length > 5) {
                return Badge(
                    // badgeColor: Colors.purple,
                    label:
                        const Text("5+", style: TextStyle(color: Colors.white)),
                    child: cartIcon);
              } else {
                return Badge(
                    // badgeColor: Colors.purple,
                    label: Text(
                      snaps.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: cartIcon);
              }
            },
          );
        });
  }
}

Widget drawerItems() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        color: primaryColor,
        height: 90,
        width: double.maxFinite,
        child: const Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "\nMENU",
              textScaleFactor: 1.2,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Get.to(() => const UserAccountScreen());
                },
                child: Row(
                  children: const [
                    Icon(MdiIcons.accountCircleOutline),
                    SizedBox(width: 10),
                    Text("Profile"),
                  ],
                )),
            TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Icon(MdiIcons.orderBoolAscending),
                    SizedBox(width: 10),
                    Text("Orders"),
                  ],
                )),
            TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Icon(MdiIcons.accountGroup),
                    SizedBox(width: 10),
                    Text("Prime"),
                  ],
                )),
            if (fireUser() != null)
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.logout),
                      SizedBox(width: 10),
                      Text("Logout"),
                    ],
                  )),
            if (fireUser() == null)
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.login),
                      SizedBox(width: 10),
                      Text("Login"),
                    ],
                  )),
          ],
        ),
      ),
    ],
  );
}
