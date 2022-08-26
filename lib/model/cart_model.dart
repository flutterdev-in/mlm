import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/services/firebase.dart';
import 'package:advaithaunnathi/hive/hive_boxes.dart';
import 'package:advaithaunnathi/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartModel {
  int nos;
  DocumentReference<Map<String, dynamic>>? thisDR;
  DocumentReference<Map<String, dynamic>> productDoc;
  int selectedPriceIndex;
  DateTime lastTime;

  CartModel({
    required this.nos,
    required this.productDoc,
    required this.lastTime,
    required this.selectedPriceIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      cartMOS.nos: nos,
      cartMOS.lastTime: Timestamp.fromDate(lastTime),
      cartMOS.productDoc: productDoc.id,
      cartMOS.selectedPriceIndex: selectedPriceIndex
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> cartMap) {
    return CartModel(
      nos: cartMap[cartMOS.nos]??1,
      selectedPriceIndex: cartMap[cartMOS.selectedPriceIndex]??0,
      productDoc:productMOS.productsCR.doc(cartMap[cartMOS.productDoc]),
      lastTime: cartMap[cartMOS.lastTime]?.toDate(),
    );
  }
}

CartModelObjects cartMOS = CartModelObjects();

class CartModelObjects {
  final nos = "nos";
  final productDoc = "productDoc";
  
  final selectedPriceIndex = "selectedPriceIndex";
  final lastTime = "lastTime";
  

  
}



