import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartModel {
  int nos;
  DocumentReference<Map<String, dynamic>>? thisDR;
  DocumentReference<Map<String, dynamic>> productDR;
  int selectedPriceIndex;
  DateTime lastTime;

  CartModel({
    required this.nos,
    required this.productDR,
    required this.lastTime,
    required this.selectedPriceIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      cartMOS.nos: nos,
      cartMOS.lastTime: Timestamp.fromDate(lastTime),
      cartMOS.productDR: productDR.id,
      cartMOS.selectedPriceIndex: selectedPriceIndex
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> cartMap) {
    return CartModel(
      nos: cartMap[cartMOS.nos] ?? 1,
      selectedPriceIndex: cartMap[cartMOS.selectedPriceIndex] ?? 0,
      productDR: productMOS.productsCR.doc(cartMap[cartMOS.productDR]),
      lastTime: cartMap[cartMOS.lastTime]?.toDate(),
    );
  }
}

CartModelObjects cartMOS = CartModelObjects();

class CartModelObjects {
  final nos = "nos";
  final productDR = "productDR";

  final selectedPriceIndex = "selectedPriceIndex";
  final lastTime = "lastTime";

  CollectionReference<Map<String, dynamic>> cartCR(User user) {
    return authUserCR.doc(user.uid).collection(cart);
  }
}
