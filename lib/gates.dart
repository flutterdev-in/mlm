import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/prime_screens/prime_home_screen.dart';
import 'package:advaithaunnathi/user/a_login_screen.dart';
import 'package:advaithaunnathi/user/user_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'prime_screens/_prime_gate.dart';

class AccountGate extends StatelessWidget {
  final bool isPrimeScreen;
  const AccountGate(this.isPrimeScreen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return
              // const SignInScreen(
              //   providerConfigs: [
              //     GoogleProviderConfiguration(
              //         clientId: "1:237115759240:android:57b787e3a03aca69fc9d3d"),
              //   ],
              // );
              const GoogleLoginView();
        } else if (snapshot.hasData && snapshot.data != null) {
          
          return isPrimeScreen
              ? 
              const PrimeHomeScreen()
              // const PrimeGate()
              : const UserAccountScreen();
        }
        return const CircularProgressIndicator();

        // Render your application if authenticated
      },
    );
  }
}
