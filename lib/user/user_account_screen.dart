import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        actions: [
          IconButton(
              onPressed: () {
                fireLogOut();
              },
              icon: const Icon(MdiIcons.logout))
        ],
      ),
    );
  }
}
