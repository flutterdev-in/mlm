import 'package:flutter/material.dart';
import 'package:advaithaunnathi/dart/repeatFunctions.dart';
import 'package:advaithaunnathi/model/address_model.dart';
import 'package:advaithaunnathi/shopping/addresses/address_edit_screen.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Addresses")),
      body: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GFButton(
                    type: GFButtonType.outline2x,
                    splashColor: Colors.blueGrey,
                    onPressed: () async {
                      await waitMilli();
                      Get.to(() => const AddressEditScreen(null));
                    },
                    child: const Text(" +   Add address   ")),
              )),
          Expanded(
            child: FirestoreListView<Map<String, dynamic>>(
                // shrinkWrap: true,
                loadingBuilder: (context) {
                  return const GFLoader();
                },
                query: addressMOs.addressCR
                    .orderBy(addressMOs.updatedTime, descending: true),
                itemBuilder: ((context, doc) {
                  var am = AddressModel.fromMap(doc.data());
                  am.docRef = doc.reference;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      child: Card(
                        elevation: 4,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(am.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "${am.house}, ${am.colony}, ${am.pinCodeModel.city}....",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("Pin code : ${am.pinCode}"),
                                  Text("Phone : ${am.phone}"),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: TextButton(
                                  onPressed: () async {
                                    await waitMilli();
                                    Get.to(() => AddressEditScreen(am));
                                  },
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }
}
