import 'package:advaithaunnathi/dart/text_formatters.dart';
import 'package:advaithaunnathi/dart/useful_functions.dart';
import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../custom widgets/stream_builder_widget.dart';
import '../dart/repeatFunctions.dart';

class ChangePassword extends StatelessWidget {
  final PrimeMemberModel pmm;
  const ChangePassword(this.pmm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var errorPassword = "".obs;
    var currentObscureTxt = false.obs;
    var newObscureTxt = false.obs;
    var tc = TextEditingController();

    String? pswd;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            StreamDocBuilder(
                stream: pmm.docRef!,
                builder: (snapshot) {
                  var pmm2 = pmm;
                  if (snapshot.exists && snapshot.data() != null) {
                    pmm2 = PrimeMemberModel.fromMap(snapshot.data()!);
                  }

                  return Obx(() => TextField(
                        maxLines: 1,
                        obscureText: currentObscureTxt.value,
                        readOnly: true,
                        controller:
                            TextEditingController(text: pmm2.userPassword),
                        // inputFormatters: [LowerCaseTextFormatter()],
                        decoration: InputDecoration(
                          suffixIcon: TextButton(
                              onPressed: () async {
                                await waitMilli(250);
                                currentObscureTxt.value =
                                    !currentObscureTxt.value;
                              },
                              child: Text(
                                  currentObscureTxt.value ? "show" : "hide")),
                          labelText: "Current Password",
                        ),
                      ));
                }),
            const SizedBox(height: 20),
            Obx(() {
              var fPass = errorPassword.value;
              bool isValid = fPass.contains("valid-");
              var error = isValid ? fPass.replaceAll("valid-", "") : fPass;

              return TextField(
                maxLines: 1,
                obscureText: newObscureTxt.value,
                controller: tc,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.name,
                inputFormatters: [LowerCaseTextFormatter()],
                decoration: InputDecoration(
                  suffixIcon: TextButton(
                      onPressed: () async {
                        await waitMilli(250);
                        newObscureTxt.value = !newObscureTxt.value;
                      },
                      child: Text(newObscureTxt.value ? "show" : "hide")),
                  labelText: "New Password",
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
                    } else if (txt.length > 15) {
                      errorPassword.value =
                          "Password contains maximum 15 characters";
                    } else {
                      pswd = txt;
                      errorPassword.value = "valid-";
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 30),
            GFButton(
                onPressed: () async {
                  await waitMilli();
                  if (pswd != null) {
                    var pmm3 = pmm;
                    pmm3.userPassword = pswd;
                    pmm3.docRef!.update(pmm3.toMap());
                    tc.clear();
                    Get.snackbar("Congrats",
                        "Your password has been updated successfully");
                  }
                },
                size: GFSize.LARGE,
                child: const Text("Change Password")),
          ],
        ),
      ),
    );
  }
}
