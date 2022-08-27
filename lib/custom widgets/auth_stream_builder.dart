import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStreamBuilder extends StatelessWidget {
  final Widget Function(User user) builder;
  final Widget? unAuthW;
  const AuthStreamBuilder({Key? key, required this.builder, this.unAuthW})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return builder(snapshot.data!);
          } else {
            return unAuthW ?? const SizedBox();
          }
        });
  }
}
