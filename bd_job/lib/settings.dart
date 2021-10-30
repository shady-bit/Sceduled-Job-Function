import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screens/HomePageScreen.dart';
import 'changeVariables.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Get.to(() => ChangeVariables());
            },
            title: Text("Modify Variables"),
            leading: Icon(Icons.change_history_rounded),
          ),
          ListTile(
            onTap: () {
              Get.to(() => HomePage());
            },
            title: Text("Run Function"),
            leading: Icon(Icons.run_circle),
          )
        ],
      ),
    );
  }
}
