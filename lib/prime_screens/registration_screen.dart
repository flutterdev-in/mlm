import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:advaithaunnathi/dart/text_formatters.dart';
import 'package:advaithaunnathi/model/razor_model.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PrimeRegistrationScreen extends StatefulWidget {
  const PrimeRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<PrimeRegistrationScreen> createState() =>
      _PrimeRegistrationScreenState();
}

class _PrimeRegistrationScreenState extends State<PrimeRegistrationScreen> {
  var interestedIn = "Marketing".obs;

  @override
  void initState() {
    regMOs.razorInIt();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumber = null;
    refererID.value = "";
    firstName = fireUser()?.displayName?.split(" ").last ?? "";
    surName = fireUser()?.displayName?.split(" ").first ?? "";
    super.dispose();
  }

  // var sfx = false.obs;
  var refererID = "".obs;
  String firstName = fireUser()?.displayName?.split(" ").last ?? "";
  String surName = fireUser()?.displayName?.split(" ").first ?? "";
  String? phoneNumber;

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration screen")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              names(),
              phone(),
              refID(),
              const SizedBox(height: 10),
              dropDown(),
              const SizedBox(height: 20),
              const Text("Prime membership : \u{20B9} 1000/-"),
              const SizedBox(height: 30),
              buyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> checkMember(String id) async {
    var k = await authUserCR
        .where(umos.memberID, isEqualTo: id)
        .limit(1)
        .get()
        .then((qs) {
      if (qs.docs.isNotEmpty && qs.docs.first.id == fireUser()?.uid) {
        return "Please enter others Reference ID";
      } else if (qs.docs.isNotEmpty && qs.docs.first.id != fireUser()?.uid) {
        return "Success";
      } else {
        return "Member does't exist please enter valid Reference ID";
      }
    });
    return k;
  }

  Widget refID() {
    var formKey = GlobalKey<FormState>();

    //
    void vld(String text) {
      regMOs.refTc = text;
      formKey.currentState?.validate().toString();
    }

    return Form(
      key: formKey,
      child: Obx(() => TextFormField(
            inputFormatters: [UpperCaseTextFormatter()],
            decoration: InputDecoration(
              errorStyle: TextStyle(
                  color: refererID.value.isNotEmpty ? Colors.green : null),
              icon: const Icon(MdiIcons.accountMultiplePlus),
              hintText: 'Please enter your referer ID',
              labelText: 'Reference ID',
              suffixIcon: refererID.value.isNotEmpty
                  ? const Icon(MdiIcons.checkCircle, color: Colors.green)
                  : null,
            ),
            maxLength: 8,
            validator: (value) {
              return regMOs.refTc;
            },
            onChanged: (v) async {
              refererID.value = '';
              if (v.isEmpty) {
                vld('');
              } else if (v == "AU0001AA") {
                vld("Success\nYour referer is Advaita Unnathi");
                refererID.value = "AU0001AA";
              } else if (v.contains(RegExp("^AU[0-9]{4}[A-Z]{2}"))) {
                vld("Please wait....");
                EasyDebounce.debounce('d', const Duration(seconds: 2),
                    () async {
                  await authUserCR
                      .where(umos.memberID, isEqualTo: v)
                      .get()
                      .then((qs) {
                    if (qs.docs.isEmpty ||
                        qs.docs.first.reference.id == fireUser()?.uid) {
                      vld("Ref ID, doesn't exist,\nPlease enter valid reference ID");
                    } else {
                      var um = UserModel.fromMap(qs.docs.first.data());
                      if (um.memberPosition != null) {
                        vld("Success\nYour referer is ${um.profileName}");
                        refererID.value = um.profileName;
                      } else {
                        vld("Your referer ${um.profileName} was not a prime member\nPlease enter valid reference ID");
                      }
                    }
                  });
                });
              } else {
                vld("Please enter valid reference ID");
              }
            },
          )),
    );
  }

  Widget dropDown() {
    return Row(
      children: [
        const Expanded(flex: 1, child: Text("Interested in")),
        Expanded(
          flex: 1,
          child: Obx(() => DropdownButtonFormField(
                // decoration: const InputDecoration(
                //     // labelText: "Post office*",
                //     // enabledBorder: OutlineInputBorder(),
                //     ),
                borderRadius: BorderRadius.circular(12),
                value: interestedIn.value,
                items: [
                  'Marketing',
                  'Stock Point',
                  'Distribution',
                  'Investment'
                ]
                    .map((e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  interestedIn.value = v.toString();
                },
              )),
        ),
      ],
    );
  }

  Widget buyButton() {
    return Obx(
      () => Align(
        alignment: Alignment.topCenter,
        child: ElevatedButton(
            onPressed: () async {
              if (isAllTrue()) {
                isLoading.value = true;
                await authUserCR
                    .doc(fireUser()?.uid)
                    .update({umos.phoneNumber: phoneNumber});
                await regMOs.razorOder(RegistrationModel(
                    orderID: null,
                    isPaid: null,
                    refMemberId:
                        refererID.value.isNotEmpty ? refererID.value : null,
                    phoneNumber: phoneNumber,
                    name: "$firstName $surName",
                    interestedIn: interestedIn.value,
                    userUID: fireUser()!.uid));

                isLoading.value = false;
              } else {
                bottomSheet();
              }
            },
            child: isLoading.value
                ? const Text("Loading....")
                : const Text("Buy now")),
      ),
    );
  }

  Widget phone() {
    return Row(
      children: [
        const Icon(MdiIcons.phone),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: "Phone number",
              // counterText: "",
            ),
            onChanged: (txt) {
              phoneNumber = txt;
            },
          ),
        ),
      ],
    );
  }

  Widget names() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(MdiIcons.accountTie),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: fireUser()?.displayName?.split(" ").last),
                decoration: const InputDecoration(
                  labelText: "First Name",
                ),
                onChanged: (txt) {
                  firstName = txt;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(MdiIcons.accountTie),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: fireUser()?.displayName?.split(" ").first),
                decoration: const InputDecoration(
                  labelText: "Last name / Surname",
                ),
                onChanged: ((txt) {
                  surName = txt;
                }),
              ),
            ),
          ],
        )
      ],
    );
  }

  bool isAllTrue() {
    if ((phoneNumber?.contains(RegExp(r'^[0-9]{10}$')) ?? false) &&
        firstName.length > 4 &&
        surName.isNotEmpty &&
        refererID.value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void bottomSheet() {
    Get.bottomSheet(Container(
      color: Colors.white,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (firstName.length < 4)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid First Name"),
            ),
          if (surName.isEmpty)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid Surname"),
            ),
          if (!(phoneNumber?.contains(RegExp(r'^[0-9]{10}$')) ?? false))
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid phone number"),
            ),
          if (refererID.value.isEmpty)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid reference ID"),
            ),
        ],
      ),
    ));
  }
}
