import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../dart/const_global_objects.dart';
import '../hive/hive_boxes.dart';
import '../services/firebase.dart';

class UserCartGate extends StatelessWidget {
  final Widget Function(CollectionReference<Map<String, dynamic>> userCartCR)
      builder;
  const UserCartGate({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (snapshot.hasData) {
          var cro = authUserCR.doc(fireUser()!.uid).collection(cart);
          return builder(cro);
        } else {
          // Render your application if authenticated
          var crf = nonAuthUserCR.doc(userBoxUID()).collection(cart);
          return builder(crf);
        }
      },
    );
  }
}
