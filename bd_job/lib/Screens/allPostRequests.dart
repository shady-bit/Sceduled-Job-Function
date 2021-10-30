import 'package:bd_job/Screens/pendingRequest.dart';
import 'package:bd_job/Screens/rejectedRequest.dart';
import 'package:bd_job/notifier/notify.dart';
import 'package:bd_job/services/utilFunctions.dart';
import 'package:bd_job/verifiedRequest.dart';
import 'package:bd_job/widgets/verifCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllPostRequests extends StatefulWidget {
  final String docId;
  final String phone;
  final String postedName;
  const AllPostRequests(
      {Key? key,
      required this.docId,
      required this.phone,
      required this.postedName})
      : super(key: key);

  @override
  _AllPostRequestsState createState() => _AllPostRequestsState();
}

class _AllPostRequestsState extends State<AllPostRequests> {
  late int donationPoints = 0;
  Map<String, dynamic> dynamicValue = {};
  final firestore = FirebaseFirestore.instance;

  void getValues() async {
    final data =
        await firestore.collection("values").doc("referralLifePoints").get();
    dynamicValue = data.data()!;
    print("fetched dynamic values");
    print(dynamicValue);
    setState(() {
      donationPoints = dynamicValue["donationPoints"];
    });
  }

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "By: ${widget.postedName}",
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    UtilFunctions.openWhatsaap(widget.phone);
                  },
                  icon: Image.asset(
                    "images/whatsapp.png",
                    height: 23,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    UtilFunctions.makePhoneCall(widget.phone, false);
                  },
                  icon: Icon(Icons.call))
            ],
            bottom: TabBar(
              labelPadding: EdgeInsets.symmetric(vertical: 10),
              tabs: [Text("Pending"), Text("Donated"), Text("Not Donated")],
            )),
        body: TabBarView(
          children: [
            PendingRequest(
              docId: widget.docId,
              donationPoints: donationPoints,
            ),
            VerifiedRequest(
              docId: widget.docId,
            ),
            RejectedRequest(docId: widget.docId)
          ],
        ),
      ),
    );
  }
}
