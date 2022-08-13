import 'package:advaithaunnathi/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../hive/hive_boxes.dart';
import '../model/cart_model.dart';
import 'const_global_strings.dart';

const authUsers = "authUsers";
const nonAuthUsers = "nonAuthUsers";

final authUserCR = FirebaseFirestore.instance.collection(authUsers);
final nonAuthUserCR = FirebaseFirestore.instance.collection(nonAuthUsers);

User? fireUser() {
  return FirebaseAuth.instance.currentUser;
}
// String? userUID = fireUser?.uid ?? userBoxUID;

Future<void> fireLogOut() async {
  await Future.delayed(const Duration(milliseconds: 300));

  await GoogleSignIn().disconnect();
  await FirebaseAuth.instance.signOut();
  userCartCR.value = nonAuthUserCR.doc(userBoxUID()).collection(cart);
}
