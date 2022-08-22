import 'package:advaithaunnathi/firebase_options.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../dart/const_global_objects.dart';
import '../dart/firebase.dart';
import '../model/cart_model.dart';

class GoogleLoginView extends StatelessWidget {
  const GoogleLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isPressed = false.obs;
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            isPressed.value = true;
            await Future.delayed(const Duration(milliseconds: 150));
            isPressed.value = false;

            await googleLoginFunction();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                SizedBox(width: 5),
                Icon(MdiIcons.google),
                Text(
                  "  Continue with Google",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

Future<void> googleLoginFunction() async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  if (kIsWeb) {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await FirebaseAuth.instance.signOut();

    await FirebaseAuth.instance
        // .signInWithRedirect(googleProvider)
        .signInWithPopup(googleProvider)
        .then((user) async {
      Get.snackbar("login", "success");
      userCartCR.value = authUserCR.doc(fireUser()!.uid).collection(cart);
      umos.userInit();
      umos.updateCartOfnonAuthUser();
    }).catchError((e) {
      Get.snackbar("Error while login", "Please try again");
    });
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    try {
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await FirebaseAuth.instance.signOut();

        await firebaseAuth
            .signInWithCredential(oAuthCredential)
            .then((user) async {
          Get.snackbar("login", "success");
          userCartCR.value = authUserCR.doc(fireUser()!.uid).collection(cart);
          umos.userInit();
          umos.updateCartOfnonAuthUser();
        }).catchError((e) {
          Get.snackbar("Error while login", "Please try again");
        });

        Get.back();
      }
    } catch (error) {
      Get.snackbar("Error while login", "Please try again");
    }
  }
}

// class GoogleSignInScreen extends StatelessWidget {
//   const GoogleSignInScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SignInScreen(providerConfigs: [
//       GoogleProviderConfiguration(
//         clientId: DefaultFirebaseOptions.web.appId,
//       ),
//     ]);
//   }
// }
