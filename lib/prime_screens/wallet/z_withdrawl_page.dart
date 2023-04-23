import 'package:flutter/material.dart';

import '../../model/prime_member_model.dart';
import 'package:collection/collection.dart';

class WithdrawalPage extends StatelessWidget {
  final PrimeMemberModel pmm;
  final num debitsAmount;
  const WithdrawalPage(this.pmm, this.debitsAmount, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var map = {
      "Total Referral Income": pmm.directIncome * 500,
      "Total Withdrwal amount": debitsAmount,
      "Shopping amount": (pmm.directIncome * 500 - debitsAmount) * 0.1,
      "Balance Amount": (pmm.directIncome * 500 - debitsAmount) * 0.9,
    };
    return Scaffold(
      appBar: AppBar(title: const Text("Referral Withdraw")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  columnWidths: const {1: FractionColumnWidth(0.2)},
                  children: map.keys
                      .toList()
                      .mapIndexed((index, key) => TableRow(
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(key,
                                      style: ([0, 3].contains(index))
                                          ? const TextStyle(
                                              fontWeight: FontWeight.bold)
                                          : null)),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      map[key]?.toStringAsFixed(1) ?? "0.0",
                                      style: ([0, 3].contains(index))
                                          ? const TextStyle(
                                              fontWeight: FontWeight.bold)
                                          : null)),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
