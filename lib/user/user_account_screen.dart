import 'package:advaithaunnathi/prime_screens/prime_login_screen.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/dart/repeatFunctions.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';

import 'package:advaithaunnathi/model/user_model.dart';

import 'package:advaithaunnathi/shopping/addresses/list_addresses_widget.dart';
import 'package:advaithaunnathi/shopping/shopping_screen_home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    isLoading.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Account")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (fireUser() != null) profileW(),
          const Divider(thickness: 2),
          GFListTile(
            avatar: const Icon(MdiIcons.orderBoolDescending),
            title: TextButton(onPressed: () {}, child: const Text("My Orders")),
          ),
          GFListTile(
            avatar: const Icon(MdiIcons.orderBoolDescendingVariant),
            title: TextButton(
                onPressed: () async {
                  await waitMilli(200)
                      .then((value) => Get.to(() => const AddressesScreen()));
                  // Get.to(() => const AddressesScreen());
                },
                child: const Text("My Addresses")),
          ),
          GFListTile(
            avatar: const Icon(MdiIcons.accountGroupOutline),
            title: TextButton(
                onPressed: () async {
                  await waitMilli();
                  Get.to(() => const PrimeLoginScreen());
                },
                child: Obx(() => isLoading.value
                    ? const Text("Loading....")
                    : const Text("Prime"))),
          ),
          GFListTile(
            avatar: const Icon(MdiIcons.logout),
            title:
                Obx(() => Text(isLoading.value ? "Please wait..." : "Logout")),
            onTap: () async {
              isLoading.value = true;
              await fireLogOut();
              isLoading.value = false;
              Get.offAll(() => const ShoppingScreenHomePage());
            },
          ),
        ],
      ),
    );
  }

  Widget profileW() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: authUserCR.doc(fireUser()!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var um = UserModel.fromMap(snapshot.data!.data()!);
            return GFListTile(
              avatar: GFAvatar(
                size: GFSize.LARGE,
                backgroundImage: um.profilePhotoUrl != null
                    ? CachedNetworkImageProvider(um.profilePhotoUrl!)
                    : null,
              ),
              title: Text(um.profileName),
              subTitleText: "${um.userEmail}\n${um.phoneNumber ?? ''}}",
              icon: IconButton(
                  onPressed: () {}, icon: const Icon(MdiIcons.pencilOutline)),
            );
          }
          return const GFListTile(
            avatar: GFAvatar(size: GFSize.LARGE),
            titleText: "   ",
            subTitleText: "    ",
          );
        });
  }
}
