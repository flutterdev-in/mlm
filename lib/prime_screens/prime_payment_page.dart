import 'package:advaithaunnathi/Prime%20models/prime_member_model.dart';
import 'package:advaithaunnathi/custom%20widgets/stream_builder_widget.dart';
import 'package:advaithaunnathi/dart/repeatFunctions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PrimePaymentPage extends StatefulWidget {
  PrimeMemberModel pmm;
  PrimePaymentPage(this.pmm, {Key? key}) : super(key: key);

  @override
  State<PrimePaymentPage> createState() => _PrimePaymentPageState();
}

class _PrimePaymentPageState extends State<PrimePaymentPage> {
  @override
  void initState() {
    primeMOs.razorInIt(widget.pmm.userName!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        actions: [
          IconButton(
            onPressed: () async {
              await waitMilli(250);
              Get.toNamed("/prime");
            },
            icon: const Icon(MdiIcons.alphaPCircleOutline),
          ),
        ],
      ),
      body: StreamDocBuilder(
          docRef: widget.pmm.docRef!,
          builder: (snapshot) {
            var pmm = PrimeMemberModel.fromMap(snapshot.data()!);
            if (pmm.isPaid == true) {
              return success(pmm);
            } else if (pmm.isPaid == false) {
              return attempted(pmm);
            } else {
              return unattempted(pmm);
            }
          }),
    );
  }

  Widget unattempted(PrimeMemberModel pmm) {
    return Column(
      children: [
        intro(pmm),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              "Proceed to pay Rs.1000/- prime member ship fee, to become a Prime member, to recieve prime benefits"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GFButton(
            child: const Text("Proceed"),
            onPressed: () async {
              await waitMilli();
              primeMOs.razorOrder(pmm);
            },
          ),
        ),
      ],
    );
  }

  Widget attempted(PrimeMemberModel pmm) {
    return Column(
      children: [
        intro(pmm),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Your previous payment is unsuccessfull / pending"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GFButton(
              child: const Text("Check status"),
              onPressed: () async {
                var isPaid =
                    await primeMOs.checkUpdateAndGetOrderStatus(pmm.userName!);
                if (isPaid) {
                  Get.snackbar(
                      "Your payment is successful", "Proceed to prime");
                } else {
                  Get.snackbar("Your payment is unsuccessful / pending",
                      "Please try again");
                }
              },
            ),
            GFButton(
              child: const Text("Pay"),
              onPressed: () async {
                await waitMilli();
                primeMOs.razorOrder(pmm);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget success(PrimeMemberModel pmm) {
    return Column(
      children: [
        const Text("Your payment is successful"),
        GFButton(
          child: const Text("Proceed to Prime"),
          onPressed: () async {
            await waitMilli();
          },
        ),
      ],
    );
  }

  Widget intro(PrimeMemberModel pmm) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Hi ${pmm.firstName} ${pmm.lastName}, Thanks for your registration to the Prime membership"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Your User Name is : ${pmm.userName}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Your Member ID is : ${pmm.memberID}"),
        ),
      ],
    );
  }
}
