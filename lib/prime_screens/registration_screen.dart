import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:advaithaunnathi/dart/text_formatters.dart';
import 'package:advaithaunnathi/model/razor_model.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PrimeRegistrationScreen extends StatefulWidget {
  const PrimeRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<PrimeRegistrationScreen> createState() =>
      _PrimeRegistrationScreenState();
}

class _PrimeRegistrationScreenState extends State<PrimeRegistrationScreen> {
  var sfx = false.obs;

  String interestedIn = "Marketing";

  @override
  void initState() {
    pmos.razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, pmos.onSuccess);
    pmos.razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, pmos.onError);
    super.initState();
  }

  @override
  void dispose() {
    pmos.razorpay.clear();
    super.dispose();
  }
  
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reg screen")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              refID(),
              dropDown(),
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
      pmos.refTc = text;
      formKey.currentState?.validate().toString();
    }

    return Form(
      key: formKey,
      child: Obx(() => TextFormField(
            inputFormatters: [UpperCaseTextFormatter()],
            decoration: InputDecoration(
              errorStyle: TextStyle(color: sfx.value ? Colors.green : null),
              icon: const Icon(MdiIcons.accountMultiplePlus),
              hintText: 'Please enter your referer ID',
              labelText: 'Reference ID',
              suffixIcon: sfx.value
                  ? const Icon(MdiIcons.checkCircle, color: Colors.green)
                  : null,
            ),
            maxLength: 8,
            validator: (value) {
              return pmos.refTc;
            },
            onChanged: (v) async {
              if (v.isEmpty) {
                sfx.value = false;
                vld('');
              } else if (v == "AU0001AA") {
                vld("Success\nYour referer is Advaita Unnathi");
                sfx.value = true;
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
                      sfx.value = false;
                    } else {
                      var um = UserModel.fromMap(qs.docs.first.data());
                      if (um.memberPosition != null) {
                        vld("Success\nYour referer is ${um.profileName}");
                        sfx.value = true;
                      } else {
                        vld("Your referer ${um.profileName} was not a prime member\nPlease enter valid reference ID");
                        sfx.value = false;
                      }
                    }
                  });
                });
              } else {
                sfx.value = false;
                vld("Please enter valid reference ID");
              }
            },
          )),
    );
  }

  Widget dropDown() {
    var dv = 'Marketing'.obs;

    return Row(
      children: [
        const Text("Interested in"),
        Container(
          height: 50,
          // width: 100,
          margin: const EdgeInsets.all(20),
          child: DropdownButtonHideUnderline(
            child: Obx(() => GFDropdown(
                  padding: const EdgeInsets.all(15),
                  borderRadius: BorderRadius.circular(10),
                  border: const BorderSide(color: Colors.black12, width: 1),
                  dropdownButtonColor: Colors.grey[300],
                  value: dv.value,
                  onChanged: (newValue) {
                    dv.value = newValue.toString();
                    interestedIn = newValue.toString();
                  },
                  items:
                      ['Marketing', 'Stock Point', 'Distribution', 'Investment']
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                )),
          ),
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
              if (sfx.value) {
                isLoading.value = true;
                await pmos.razorOder();
                await Future.delayed(const Duration(seconds: 3));
                isLoading.value = false;
              } else {
                Get.snackbar("Error", "Please enter valid reference ID",
                    backgroundColor: Colors.white, colorText: Colors.red);
              }
            },
            child: isLoading.value
                ? const Text("Loading....")
                : const Text("Buy now")),
      ),
    );
  }
}

