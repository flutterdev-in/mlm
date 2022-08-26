import 'package:advaithaunnathi/Prime%20models/prime_member_model.dart';
import 'package:advaithaunnathi/dart/text_formatters.dart';
import 'package:advaithaunnathi/dart/useful_functions.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                labelText: "User Name",
                errorText: error.isNotEmpty ? error : null,
                errorStyle:
                    isValid ? const TextStyle(color: Colors.green) : null,
              ),
              onChanged: (txt) async {
                userNm = null;
                errorUserName.value = "";
                afterDebounce(after: () async {
                  if (txt.length < 6) {
                    errorUserName.value =
                        "User name contains minimum 6 characters";
                  } else if (txt.length > 15) {
                    errorUserName.value =
                        "User name contains maximum 15 characters";
                  } else if (txt.contains(RegExp(r'^[a-z0-9]{6,15}$'))) {
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
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
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
                  if (userNm != null && pswd != null) {
                    await primeMOs.primeMemberDR(userNm!).get().then((ds) {
                      if (ds.exists && ds.data() != null) {
                        var pmm = PrimeMemberModel.fromMap(ds.data()!);
                        if (pmm.userPassword != pswd) {
                          pswd = null;
                          errorPassword.value = "Incorrect Password";
                        }
                      } else {
                        userNm = null;
                        errorUserName.value = "Incorrect User Name";
                      }
                    });
                  }
                },
                child: isLoading.value
                    ? const Text("Loading....")
                    : const Text("   Login   ")),
          ),
        ),
      ],
    );
  }
}
