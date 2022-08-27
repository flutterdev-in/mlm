import 'package:advaithaunnathi/matrix/matrix_income.dart';
import 'package:advaithaunnathi/matrix/net_matrix_income.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'prime_member_model.dart';

class WithdrawModel {
  bool isMatrix;
  String userName;
  int memberPosition;
  int amount;
  DateTime requestedTime;
  bool isSettled;
  String? adminComments;
  String? transactionNumber;
  DateTime? transactionTime;
  bool? isCustomerRecd;
  DateTime? reminderTime;
  bool? isCoinsWithdraw;
  DocumentReference<Map<String, dynamic>>? docRef;

  WithdrawModel({
    required this.isMatrix,
    required this.userName,
    required this.memberPosition,
    required this.amount,
    required this.requestedTime,
    required this.isSettled,
    required this.adminComments,
    required this.transactionNumber,
    required this.isCustomerRecd,
    required this.reminderTime,
    required this.isCoinsWithdraw,
    required this.transactionTime,
  });

  Map<String, dynamic> toMap() {
    return {
      withdrawMOs.isMatrix: isMatrix,
      withdrawMOs.userName: userName,
      withdrawMOs.memberPosition: memberPosition,
      withdrawMOs.amount: amount,
      withdrawMOs.requestedTime: requestedTime,
      withdrawMOs.isSettled: isSettled,
      withdrawMOs.adminComments: adminComments,
      withdrawMOs.transactionNumber: transactionNumber,
      withdrawMOs.transactionTime: transactionTime,
      withdrawMOs.isCustomerRecd: isCustomerRecd,
      withdrawMOs.reminderTime: reminderTime,
      withdrawMOs.isCoinsWithdraw: isCoinsWithdraw,
    };
  }

  factory WithdrawModel.fromMap(Map<String, dynamic> withMap) {
    return WithdrawModel(
      isMatrix: withMap[withdrawMOs.isMatrix],
      userName: withMap[withdrawMOs.userName],
      memberPosition: withMap[withdrawMOs.memberPosition],
      amount: withMap[withdrawMOs.amount],
      requestedTime: withMap[withdrawMOs.requestedTime]?.toDate(),
      isSettled: withMap[withdrawMOs.isSettled],
      adminComments: withMap[withdrawMOs.adminComments],
      transactionNumber: withMap[withdrawMOs.transactionNumber],
      isCustomerRecd: withMap[withdrawMOs.isCustomerRecd],
      reminderTime: withMap[withdrawMOs.reminderTime],
      transactionTime: withMap[withdrawMOs.transactionTime],
      isCoinsWithdraw: withMap[withdrawMOs.isCoinsWithdraw],
    );
  }
}

WithdrawModelObjects withdrawMOs = WithdrawModelObjects();

class WithdrawModelObjects {
  final isMatrix = "isMatrix";
  final userName = "userName";
  final memberPosition = "memberPosition";
  final amount = "amount";
  final requestedTime = "requestedTime";
  final isSettled = "isSettled";
  final adminComments = "adminComments";
  final transactionNumber = "transactionNumber";
  final transactionTime = "transactionTime";
  final isCustomerRecd = "isCustomerRecd";
  final reminderTime = "reminderTime";
  final isCoinsWithdraw = "isCoinsWithdraw";

  //
  final withdrawals = "withdrawals";

  //
  CollectionReference<Map<String, dynamic>> withdrawalsCR() {
    return FirebaseFirestore.instance.collection(withdrawals);
  }

  WithdrawModel wmFromPMM(
      {required PrimeMemberModel pmm,
      required bool isMatrix,
      required int amount}) {
    return WithdrawModel(
        isMatrix: isMatrix,
        userName: pmm.userName!,
        memberPosition: pmm.memberPosition!,
        amount: amount,
        requestedTime: DateTime.now(),
        isSettled: false,
        adminComments: null,
        transactionNumber: null,
        reminderTime: null,
        transactionTime: null,
        isCoinsWithdraw: null,
        isCustomerRecd: false);
  }

  Future<bool?> isPendingWithdraw(PrimeMemberModel pmm, bool isMatrix) async {
    bool? isPending;
    await withdrawalsCR()
        .where(withdrawMOs.userName, isEqualTo: pmm.userName)
        .where(withdrawMOs.isMatrix, isEqualTo: isMatrix)
        .where(withdrawMOs.isCustomerRecd, isEqualTo: false)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isPending = true;
      } else {
        isPending = false;
      }
    });

    return null;
  }

  Stream<List<int>> streamWithdrawalAmountList(
      PrimeMemberModel pmm, bool isMatrix) {
    return withdrawalsCR()
        .where(withdrawMOs.userName, isEqualTo: pmm.userName)
        .where(withdrawMOs.isMatrix, isEqualTo: isMatrix)
        .where(withdrawMOs.isCustomerRecd, isEqualTo: true)
        .snapshots()
        .map((qs) => qs.docs.map((qds) {
              var wm = WithdrawModel.fromMap(qds.data());
              return wm.amount;
            }).toList());
  }

  //
  Future<int> futureWithdrawalAmount(
      PrimeMemberModel pmm, bool isMatrix) async {
    return await withdrawalsCR()
        .where(withdrawMOs.userName, isEqualTo: pmm.userName)
        .where(withdrawMOs.isMatrix, isEqualTo: isMatrix)
        .where(withdrawMOs.isCustomerRecd, isEqualTo: true)
        .get()
        .then((qs) {
      int amount = 0;
      if (qs.docs.isNotEmpty) {
        for (var qds in qs.docs) {
          var wm = WithdrawModel.fromMap(qds.data());
          amount += wm.amount;
        }
      }
      return amount;
    });
  }

  int listAmount(List<int> list) {
    int amount = 0;
    if (list.isNotEmpty) {
      for (var element in list) {
        amount += element;
      }
    }
    return amount;
  }

  Future<int> matrixIncomeF(int thisPos) async {
    var lastPM = await primeMOs.getLastPrimeMemberModel();
    if (lastPM?.memberPosition != null) {
      return matrixIncome(thisPos, lastPM!.memberPosition!);
    } else {
      return matrixIncome(thisPos, thisPos);
    }
  }

  Future<int> netIncome(PrimeMemberModel pmm, bool isMatrix) async {
    var withAmt = await futureWithdrawalAmount(pmm, isMatrix);
    if (isMatrix) {
      var mi = await matrixIncomeF(pmm.memberPosition!);
      return mi - withAmt - blockedMatrixIncome(mi);
    } else {
      return pmm.directIncome - withAmt;
    }
  }
}
