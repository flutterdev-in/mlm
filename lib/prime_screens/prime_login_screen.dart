import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:advaithaunnathi/dart/repeatFunctions.dart';
import 'package:advaithaunnathi/dart/text_formatters.dart';
import 'package:advaithaunnathi/dart/useful_functions.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:advaithaunnathi/hive/hive_boxes.dart';
import 'package:advaithaunnathi/prime_screens/prime_home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'prime_payment_page.dart';

class PrimeLoginScreen extends StatefulWidget {
  const PrimeLoginScreen({Key? key}) : super(key: key);

  @override
  State<PrimeLoginScreen> createState() => _PrimeLoginScreenState();
}

class _PrimeLoginScreenState extends State<PrimeLoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //

  var errorUserName = "".obs;

  var errorPassword = "".obs;

  var isValidUser = false.obs;

  String? userNm;
  String? pswd;

  //

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prime Login")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoaPLPMZE1sJX9Ik_FtKM8X1mwam4TnVBgjA&usqp=CAU",
                  )),
              const SizedBox(height: 15),
              userName(),
              password(),
              const SizedBox(height: 15),
              login(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget userName() {
    var un = servicesBox.get(primeMOs.userName) as String?;
    var tc = TextEditingController();
    tc.text = un ?? "";
    userNm = un;
    return Row(
      children: [
        const Icon(MdiIcons.accountQuestion),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Obx(() {
            bool isValid = errorUserName.value.contains("valid-");
            var error = isValid
                ? errorUserName.value.replaceAll("valid-", "")
                : errorUserName.value;

            return TextField(
              maxLines: 1,
              autofocus: true,
              controller: tc,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                labelText: "User Name",
                errorText: error.isNotEmpty ? error : null,
                errorStyle:
                    isValid ? const TextStyle(color: Colors.green) : null,
              ),
              onChanged: (txt) async {
                userNm = null;
                txt.toLowerCase().trim();
                errorUserName.value = "";
                afterDebounce(after: () async {
                  if (txt.length < 6) {
                    errorUserName.value =
                        "User name contains minimum 6 characters";
                  } else if (txt.length > 30) {
                    errorUserName.value =
                        "User name contains maximum 30 characters";
                  } else if (txt.contains(RegExp(r'^[a-z0-9]{6,30}$'))) {
                    userNm = txt.toLowerCase();
                    errorUserName.value = "valid-";
                  } else {
                    errorUserName.value =
                        "User name contains only letters and numbers";
                  }
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget password() {
    var obscureTxt = false.obs;
    return Row(
      children: [
        const Icon(MdiIcons.lockOutline),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Obx(() {
            var fPass = errorPassword.value;
            bool isValid = fPass.contains("valid-");
            var error = isValid ? fPass.replaceAll("valid-", "") : fPass;

            return TextField(
              maxLines: 1,
              obscureText: obscureTxt.value,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.name,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                suffixIcon: TextButton(
                    onPressed: () async {
                      await waitMilli(250);
                      obscureTxt.value = !obscureTxt.value;
                    },
                    child: Text(obscureTxt.value ? "show" : "hide")),
                labelText: "Enter Password",
                errorText: error.isNotEmpty
                    ? isValid
                        ? "Password Valid"
                        : error
                    : null,
                errorStyle:
                    isValid ? const TextStyle(color: Colors.green) : null,
              ),
              onChanged: (txt) async {
                afterDebounce(after: () async {
                  if (txt.length < 4) {
                    errorPassword.value =
                        "Password contains minimum 4 characters";
                  } else if (txt.length > 10) {
                    errorPassword.value =
                        "Password contains maximum 10 characters";
                  } else {
                    pswd = txt;
                    errorPassword.value = "valid-";
                  }
                });
              },
              onSubmitted: (value) async {
                await onSubmit();
              },
            );
          }),
        ),
      ],
    );
  }

  Widget login() {
    return Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {}, child: const Text("Forgot Password?"))),
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
                onPressed: () async {
                  await onSubmit();
                },
                child: SizedBox(
                    width: 100,
                    child: Center(
                        child: isLoading.value
                            ? const Text("Loading....")
                            : const Text("Login")))),
          ),
        ),
      ],
    );
  }

  Future<void> onSubmit() async {
    isLoading.value = true;
    if (userNm != null && pswd != null) {
      await primeMOs.primeMemberDR(userNm!).get().then((ds) async {
        if (ds.exists && ds.data() != null) {
          var pmm = PrimeMemberModel.fromMap(ds.data()!);
          pmm.docRef = ds.reference;

          if (pmm.userPassword != pswd) {
            pswd = null;
            errorPassword.value = "Incorrect Password";
          } else {
            errorPassword.value = "Incorrectdd";
            await onValid(pmm);
          }
        } else {
          userNm = null;
          errorUserName.value = "Incorrect User Name";
        }
      });
    } else if (userNm == null) {
      errorUserName.value = "Please enter User Name";
    } else if (pswd == null) {
      errorPassword.value = "Please enter Password";
    }

    isLoading.value = false;
  }

  Future<void> onValid(PrimeMemberModel pmm) async {
    servicesBox.put(primeMOs.userName, pmm.userName);
    if (pmm.isPaid != true || pmm.memberPosition == null) {
      var isPaid = await primeMOs.checkUpdateAndGetOrderStatus(pmm.userName!);
      if (isPaid) {
        var pm = await primeMOs.getPrimeMemberModel(pmm.userName!);
        Get.to(() => PrimeHomeScreen(pm ?? pmm));
      } else {
        Get.to(() => PrimePaymentPage(pmm));
      }
    } else {
      Get.to(() => PrimeHomeScreen(pmm));
    }
  }
}
