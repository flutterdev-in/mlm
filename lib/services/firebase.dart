import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const authUsers = "authUsers";

final authUserCR = FirebaseFirestore.instance.collection(authUsers);
// final nonAuthUserCR = FirebaseFirestore.instance.collection(nonAuthUsers);

//

final storageRef = FirebaseStorage.instance.ref();

User? fireUser() {
  return FirebaseAuth.instance.currentUser;
}
// String? userUID = fireUser?.uid ?? userBoxUID;

Future<void> fireLogOut() async {
  await Future.delayed(const Duration(milliseconds: 300));
  // if (!kIsWeb) {
  //   await GoogleSignIn().disconnect();
  // }

  await FirebaseAuth.instance.signOut();
  // userCartCR.value = nonAuthUserCR.doc(userBoxUID()).collection(cart);
}
