import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const authUsers = "authUsers";

final authUserCR = FirebaseFirestore.instance.collection(authUsers);
final fireUser = FirebaseAuth.instance.currentUser;
String? userUID = fireUser?.uid;

Future<void> fireLogOut() async {
  if (fireUser != null) {
    await Future.delayed(const Duration(milliseconds: 300));

    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
