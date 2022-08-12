import 'package:advaithaunnathi/dart/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../model/product_model.dart';

class PrimeHomeScreen extends StatelessWidget {
  const PrimeHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prime Login Page"), centerTitle: true),
      drawer: Drawer(
        // backgroundColor: Colors.pink.shade100,
        width: Get.width - 50,
        child: drawerItems(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: Get.width,
              child: const Expanded(
                child: Card(
                    child: Center(
                  child: Text("ADVAITAUNNATHI",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold)),
                )),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextButton(onPressed: ()async{

              await  addDummyProductsToFire();
           
          }, child: const Text("BUY")),
              const Text("|"),
              TextButton(onPressed: () {}, child: const Text("SELL")),
              const Text("|"),
              TextButton(onPressed: () {}, child: const Text("REFFER")),
            ]),
            CarouselSlider.builder(
              options: CarouselOptions(
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                height: 130.0,
                viewportFraction: 0.7,

                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 600),
                // padEnds: false,
                // clipBehavior: Clip.antiAlias,
              ),
              itemCount: 8,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                color: Colors.orange.shade100,
                child: Center(child: Text(itemIndex.toString())),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 150,
              width: 200,
              color: Colors.green.shade200,
              child: const Center(
                  child: Text("Notice\nBoard", textScaleFactor: 2)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  Container(
                      color: Colors.purple.shade100,
                      child: const GridTile(
                          child: Center(child: Text("product")))),
                  Container(
                      color: Colors.purple.shade100,
                      child: const GridTile(
                          child: Center(child: Text("product")))),
                  Container(
                      color: Colors.purple.shade100,
                      child: const GridTile(
                          child: Center(child: Text("product")))),
                  Container(
                      color: Colors.purple.shade100,
                      child: const GridTile(
                          child: Center(child: Text("product")))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.account),
                      SizedBox(width: 10),
                      Text("Profile"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.wallet),
                      SizedBox(width: 10),
                      Text("Wallet"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.accountGroup),
                      SizedBox(width: 10),
                      Text("Level users"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.accountMultiplePlus),
                      SizedBox(width: 10),
                      Text("Direct referrals"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.shieldCheck),
                      SizedBox(width: 10),
                      Text("KYC Details page"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.cash),
                      SizedBox(width: 10),
                      Text("Redeem AU Coins"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.trainCar),
                      SizedBox(width: 10),
                      Text("Tours"),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
