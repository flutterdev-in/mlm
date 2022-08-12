import 'package:advaithaunnathi/dart/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GoogleLoginView extends StatelessWidget {
  const GoogleLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isPressed = false.obs;
    return Scaffold(
      body: Container(
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: Get.height * 0.5,
                child: const Center(child: Text("Please login"))),
            SizedBox(
              height: Get.height * 0.3,
              child: Center(
                child: InkWell(
                  child: Obx(() => Card(
                        color: Colors.black12,
                        elevation: isPressed.value ? 0 : 4,
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
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
                      )),
                  onTap: () async {
                    isPressed.value = true;
                    await Future.delayed(const Duration(milliseconds: 150));
                    isPressed.value = false;
                    await login();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.signOut();

      await firebaseAuth.signInWithCredential(oAuthCredential).then((user) {
        Get.snackbar("login", "success");
      }).catchError((e) {
        Get.snackbar("Error while login", "Please try again");
      });

      Get.back();
    } catch (error) {
      Get.snackbar("Error while login", "Please try again");
    }
  }
}
