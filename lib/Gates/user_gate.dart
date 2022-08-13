import 'package:advaithaunnathi/dart/colors.dart';
import 'package:advaithaunnathi/user/user_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const LoginView();
          // SignInScreen(
          //   providerConfigs: [
          //     GoogleProviderConfiguration(
          //         clientId: kIsWeb
          //             ? DefaultFirebaseOptions.web.appId
          //             : DefaultFirebaseOptions.android.appId),
          //   ],
          // );
          // const LoginView();
        } else if (snapshot.hasData && snapshot.data != null) {
          return const UserAccountScreen();
        }
        return const CircularProgressIndicator();
        // Render your application if authenticated
      },
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isPressed = false.obs;
    return Scaffold(
      appBar: AppBar(title: const Text("My Account")),
      body: Container(
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.5, child: const Text("Login")),
            SizedBox(
              height: Get.height * 0.2,
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

      await firebaseAuth.signInWithCredential(oAuthCredential);

      Get.back();
    } catch (error) {
      Get.snackbar("Error while login", "Please try again");
    }
  }
}
