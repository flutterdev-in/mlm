import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/model/prime_member_model.dart';
import 'package:advaithaunnathi/custom%20widgets/stream_single_query_builder.dart';
import 'package:advaithaunnathi/dart/text_formatters.dart';
import 'package:advaithaunnathi/dart/useful_functions.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:advaithaunnathi/policies/policies_card.dart';
import 'package:advaithaunnathi/prime_screens/prime_payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

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
  @override
  void initState() {
    // servicesBox.put(primeMOs.refMemberId, Get.parameters[primeMOs.refMemberId]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  var interestedIn = "Marketing".obs;
  var errorFirstName = "".obs;
  var errorLastName = "".obs;
  var errorPhoneNumber = "".obs;
  var errorEmail = "".obs;
  var errorUserName = "".obs;

  var errorConfirmPassword = "".obs;

  //
  var pmm = PrimeMemberModel(
    memberPosition: null,
    firstName: null,
    lastName: null,
    memberID: null,
    email: null,
    phoneNumber: null,
    refMemberId: null,
    directIncome: 0,
    orderID: null,
    isPaid: null,
    interestedIn: null,
    userName: null,
    userPassword: null,
    profilePhotoUrl: null,
    fcmToken: null,
    userRegTime: null,
  );

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration screen")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  firstNameW(),
                  lastNameW(),
                  phone(),
                  email(),
                  refIdW(),
                  userName(),
                  password(),
                  const SizedBox(height: 10),
                  dropDown(),
                  const SizedBox(height: 15),
                  signUp(),
                  const Text(appUpdatedTime),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDown() {
    pmm.interestedIn = interestedIn.value;
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
                  pmm.interestedIn = v.toString();
                },
              )),
        ),
      ],
    );
  }

  Widget firstNameW() {
    var tc = TextEditingController();
    return Row(
      children: [
        const Icon(MdiIcons.accountTie),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Obx(() => TextField(
                maxLines: 1,
                controller: tc,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "First Name",
                  errorText: errorFirstName.value.isNotEmpty
                      ? errorFirstName.value
                      : null,
                ),
                onChanged: (txt) {
                  pmm.firstName = null;
                  errorFirstName.value = "";
                  txt.trim();
                  afterDebounce(after: () async {
                    if (txt.length > 4) {
                      pmm.firstName = txt;
                    } else {
                      errorFirstName.value = "Please enter valid first name";
                    }
                  });
                },
              )),
        ),
      ],
    );
  }

  Widget lastNameW() {
    var tc = TextEditingController();
    return Row(
      children: [
        const Icon(MdiIcons.accountTie),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Obx(() => TextField(
                controller: tc,
                maxLines: 1,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Last Name / Surname",
                  errorText: errorLastName.value.isNotEmpty
                      ? errorLastName.value
                      : null,
                ),
                onChanged: (txt) {
                  pmm.lastName = null;
                  errorLastName.value = "";
                  afterDebounce(after: () async {
                    if (txt.length > 1) {
                      pmm.lastName = txt;
                    } else {
                      errorLastName.value = "Please enter valid Surname";
                    }
                  });
                },
              )),
        ),
      ],
    );
  }

  Widget phone() {
    var tc = TextEditingController();
    return Row(
      children: [
        const Icon(MdiIcons.phone),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Obx(() => TextField(
                controller: tc,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Phone number",
                  errorText: errorPhoneNumber.value.isNotEmpty
                      ? errorPhoneNumber.value
                      : null,
                ),
                onChanged: (txt) {
                  pmm.phoneNumber = null;
                  errorPhoneNumber.value = "";
                  afterDebounce(after: () async {
                    if (txt.contains(RegExp(r'^[0-9]{10}$'))) {
                      pmm.phoneNumber = txt;
                    } else {
                      errorPhoneNumber.value =
                          "Please enter valid Phone number";
                    }
                  });
                },
              )),
        ),
      ],
    );
  }

  Widget email() {
    var tc = TextEditingController();
    return Row(
      children: [
        const Text(
          "@",
          textScaleFactor: 1.5,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Obx(() => TextField(
                controller: tc,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: "Email address",
                  errorText:
                      errorEmail.value.isNotEmpty ? errorEmail.value : null,
                ),
                onChanged: (txt) {
                  pmm.email = null;
                  errorEmail.value = "";
                  afterDebounce(after: () async {
                    if (txt.isEmail) {
                      pmm.email = txt;
                    } else {
                      errorEmail.value = "Please enter valid Email address";
                    }
                  });
                },
              )),
        ),
      ],
    );
  }

  Widget userName() {
    var tc = TextEditingController();
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
              controller: tc,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                labelText: "User Name",
                errorText: error.isNotEmpty ? error : null,
                errorStyle:
                    isValid ? const TextStyle(color: Colors.green) : null,
              ),
              onChanged: (txt) async {
                pmm.userName = null;
                errorUserName.value = "";
                afterDebounce(after: () async {
                  if (txt.length < 6) {
                    errorUserName.value =
                        "User name contains minimum 6 characters";
                  } else if (txt.length > 30) {
                    errorUserName.value =
                        "User name contains maximum 30 characters";
                  } else if (txt.contains(RegExp(r'^[a-z0-9]{6,30}$'))) {
                    errorUserName.value = "Please wait...";
                    await primeMOs.primeMemberDR(txt).get().then((ds) {
                      if (ds.exists && ds.data() != null) {
                        errorUserName.value = "User name not available";
                      } else {
                        pmm.userName = txt.toLowerCase();
                        errorUserName.value = "valid-User name available";
                      }
                    });
                  } else {
                    errorUserName.value = "Only letters and numbers allowed";
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
    var firstPassword = "".obs;
    var confirmPassword = "".obs;
    var ftc = TextEditingController();
    var ctc = TextEditingController();
    return Column(
      children: [
        Row(
          children: [
            const Icon(MdiIcons.lockOutline),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Obx(() {
                var fPass = firstPassword.value;
                bool isValid = fPass.contains("valid-");
                var error = isValid ? fPass.replaceAll("valid-", "") : fPass;

                return TextField(
                  maxLines: 1,
                  controller: ftc,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
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
                    pmm.userPassword = null;
                    firstPassword.value = "";
                    confirmPassword.value = "";
                    afterDebounce(after: () async {
                      if (txt.length < 4) {
                        firstPassword.value =
                            "Password contains minimum 4 characters";
                      } else if (txt.length > 10) {
                        firstPassword.value =
                            "Password contains maximum 10 characters";
                      } else {
                        firstPassword.value = "valid-$txt";
                      }
                    });
                  },
                );
              }),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(MdiIcons.lockCheckOutline),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Obx(() {
                var fpass = firstPassword.value;
                bool isFvalid = firstPassword.value.contains("valid-");
                fpass = isFvalid ? fpass.replaceAll("valid-", "") : fpass;

                bool isValid = confirmPassword.value.contains("valid-");
                var error = isValid
                    ? confirmPassword.value.replaceAll("valid-", "")
                    : confirmPassword.value;

                return TextField(
                  maxLines: 1,
                  controller: ctc,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.go,
                  inputFormatters: [LowerCaseTextFormatter()],
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    errorText: error.isNotEmpty ? error : null,
                    errorStyle:
                        isValid ? const TextStyle(color: Colors.green) : null,
                  ),
                  onChanged: (txt) async {
                    pmm.userPassword = null;
                    confirmPassword.value = "";
                    afterDebounce(after: () async {
                      if (isFvalid && txt == fpass) {
                        pmm.userPassword = txt;
                        confirmPassword.value = "valid-Password matched";
                      } else {
                        confirmPassword.value = "Password not matched";
                      }
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  bool isAllTrue() {
    if (pmm.firstName != null &&
        pmm.lastName != null &&
        pmm.phoneNumber != null &&
        pmm.email != null &&
        pmm.userName != null &&
        pmm.refMemberId != null) {
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
          if (pmm.firstName == null)
            const Padding(
                padding: EdgeInsets.all(3.0),
                child: Text("Please enter valid First Name")),
          if (pmm.lastName == null)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid Surname"),
            ),
          if (pmm.phoneNumber == null)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid phone number"),
            ),
          if (pmm.email == null)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid Email address"),
            ),
          if (pmm.refMemberId == null)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                  "Refferar is not a prime member, please get valid refferar link"),
            ),
          if (pmm.userName == null)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid User Name"),
            ),
          if (pmm.userPassword == null)
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("Please enter valid Password"),
            ),
        ],
      ),
    ));
  }

  Widget refIdW() {
    String? refID = Get.parameters[primeMOs.refMemberId] ?? "AU6293CG";
    return Column(
      children: [
        Row(
          children: [
            const Icon(MdiIcons.accountGroup),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                  readOnly: true,
                  controller: TextEditingController(text: refID),
                  decoration: const InputDecoration(
                    labelText: "Referrer ID",
                  )),
            ),
          ],
        ),
        StreamSingleQueryBuilder(
          query: primeMOs
              .primeMembersCR()
              .where(primeMOs.memberID, isEqualTo: refID),
          builder: (docSnap) {
            var pmm0 = PrimeMemberModel.fromMap(docSnap.data());
            if (refID != "xxx" &&
                pmm0.memberPosition != null &&
                pmm0.isPaid == true) {
              pmm.refMemberId = refID;
              return Text(
                "Your referrer is '${pmm0.firstName} ${pmm0.lastName}'",
                style: const TextStyle(color: Colors.green),
              );
            } else {
              return const Text(
                  "Refferar is not a prime member, please get valid refferar link",
                  style: TextStyle(color: Colors.orange));
            }
          },
          noResultsW: const Text(
              "Refferar is not exists, please get valid refferar link",
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget signUp() {
    return Container(
      color: Colors.brown.shade50,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: RichText(
              text: TextSpan(
                  text: 'By signing up, you agree to our ',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Terms and Privacy Policy',
                        style: const TextStyle(
                            color: Colors.blueAccent, fontSize: 18),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const PolicyScreen(
                                "Terms and Privacy Policy",
                                '''Membership Eligibility\n
Transaction on the Platform is available only to persons who can form legally binding contracts
under Indian Contract Act, 1872. Persons who are "incompetent to contract" within the meaning of
the Indian Contract Act, 1872 including un-discharged insolvents etc. are not eligible to use the
Platform. If you are a minor i.e. under the age of 18 years, you may use the Platform or access
content on the Platform only under the supervision and prior consent/ permission of a parent or
legal guardian.
As a minor if you wish to transact on the Platform, such transaction on the Platform may be made
by your legal guardian or parents. Advaita reserves the right to terminate your membership and / or
refuse to provide you with access to the Platform if it is brought to Advaita's notice or if it is
discovered that You are under the age of 18 years and transacting on the Platform.\n\n
Your Account and Registration Obligations\n
If you use the Platform, You shall be responsible for maintaining the confidentiality of your Display
Name and Password and you shall be responsible for all activities that occur under your Display
Name and Password. You agree that if You provide any information that is untrue, inaccurate, not
current or incomplete or We have reasonable grounds to suspect that such information is untrue,
inaccurate, not current or incomplete, or not in accordance with the this Terms of Use, We shall
have the right to indefinitely suspend or terminate or block access of your membership on the
Platform and refuse to provide You with access to the Platform.
Your mobile phone number and/or e-mail address is treated as your primary identifier on the
Platform. It is your responsibility to ensure that Your mobile phone number and your email address
is up to date on the Platform at all times. You agree to notify Us promptly if your mobile phone
number or e-mail address changes by updating the same on the Platform through a onetime
password verification.
You agree that Advaita shall not be liable or responsible for the activities or consequences of use or
misuse of any information that occurs under your Account in cases, including, where You have failed
to update Your revised mobile phone number and/or e-mail address on the Website Platform.
If You share or allow others to have access to Your account on the Platform (“Account”), by creating
separate profiles under Your Account, or otherwise, they will be able to view and access YourAccount information. You shall be solely liable and responsible for all the activities undertaken
under Your Account, and any consequences therefrom.'''));
                          })
                  ]),
            ),
          ),
          Obx(
            () => Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () async {
                  if (isAllTrue()) {
                    isLoading.value = true;
                    pmm.userRegTime = DateTime.now();
                    pmm.docRef = primeMOs.primeMemberDR(pmm.userName!);
                    await pmm.docRef!.set(pmm.toMap(), SetOptions(merge: true));
                    isLoading.value = false;
                    //Member id & Order Id will be created and updated by Firebase Functions
                    Get.to(() => PrimePaymentPage(pmm));
                  } else {
                    bottomSheet();
                  }
                },
                child: SizedBox(
                  width: 150,
                  child: Align(
                    alignment: Alignment.center,
                    child: isLoading.value
                        ? const Text("Loading....")
                        : const Text("Sign up"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
