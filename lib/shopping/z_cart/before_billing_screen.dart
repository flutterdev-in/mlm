import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BeforeBillingScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> cartDocSnaps;
  final num totalPrice;
  final num totalMrp;

  const BeforeBillingScreen({
    Key? key,
    required this.cartDocSnaps,
    required this.totalPrice,
    required this.totalMrp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart overview")),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
