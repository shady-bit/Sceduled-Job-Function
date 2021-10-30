import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Notify extends ChangeNotifier {
  Map<String, dynamic> dynamicValue = {};
  final firestore = FirebaseFirestore.instance;
  Notify() {
    getValues();
  }

  void getValues() async {
    final data =
        await firestore.collection("values").doc("referralLifePoints").get();
    dynamicValue = data.data()!;
    print("fetched dynamic values");
    print(dynamicValue);
    notifyListeners();
  }
}
