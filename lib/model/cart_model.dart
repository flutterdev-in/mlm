import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  int nos;
  DocumentReference<Map<String, dynamic>>? thisDR;
  DocumentReference<Map<String, dynamic>> productDoc;

  DateTime lastTime;

  CartModel({
    required this.nos,
    required this.productDoc,
    required this.lastTime,
  });

  Map<String, dynamic> toMap() {
    return {
      cartMOS.nos: nos,
      cartMOS.lastTime: Timestamp.fromDate(lastTime),
      cartMOS.productDoc: productDoc.id,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> cartMap) {
    return CartModel(
      nos: cartMap[cartMOS.nos],
      productDoc: cartMOS.authUserCartCR.doc(cartMap[cartMOS.productDoc]),
      lastTime: cartMap[cartMOS.lastTime]?.toDate(),
    );
  }
}

CartModelObjects cartMOS = CartModelObjects();

class CartModelObjects {
  final nos = "nos";
  final productDoc = "productDoc";
  

  final lastTime = "lastTime";

  final authUserCartCR = authUserCR.doc(fireUser!.uid).collection("cart");
}
