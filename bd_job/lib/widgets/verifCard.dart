import 'package:bd_job/services/utilFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fullPagePhoto.dart';
import 'labelContainer.dart';

class VerifCard extends StatefulWidget {
  final String donorPhone;
  final String donorName;
  final String postId;
  final String imageUrl;
  final String userId;
  final Timestamp timestamp;
  final String donatedType;
  final String unitsDonated;
  final String patientName;
  const VerifCard(
      {Key? key,
      required this.donorPhone,
      required this.donorName,
      required this.postId,
      required this.imageUrl,
      required this.userId,
      required this.donatedType,
      required this.unitsDonated,
      required this.patientName,
      required this.timestamp})
      : super(key: key);

  @override
  _VerifCardState createState() => _VerifCardState();
}

class _VerifCardState extends State<VerifCard> {
  late int donationPoints;

  String timeStampToDate(Timestamp timestamp) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    final DateFormat serverFormatter = DateFormat('yMMMMd');
    final String formatted = serverFormatter.format(date);
    return formatted.toString();
  }

  updateLifePoints(String uid) {
    FirebaseFirestore.instance
        .collection("Profile")
        .doc(uid)
        .update({"lifePoints": FieldValue.increment(donationPoints)});
  }

  setToNotification({String? uid, String? myName, String? postId}) async {
    await updateLifePoints(uid!);
    if (donationPoints != 0) {
      print("Inside notification");
      FirebaseFirestore.instance
          .collection("Profile")
          .doc(uid)
          .collection("notifications")
          .add({
        "timeStamp": FieldValue.serverTimestamp(),
        "tag": "Accepted",
        "points": donationPoints,
        "badge": "lifePoints",
        "receivedFrom": myName,
        "postId": postId,
      }).then((value) => print("Notification Sent for Acceptance"));
    }
  }

  Future getDonationPoints() async {
    FirebaseFirestore.instance
        .collection("values")
        .doc("referralLifePoints")
        .get()
        .then((value) {
      setState(() {
        donationPoints = value.data()!["donationPoints"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDonationPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 15, 8, 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          FullScreenPhoto(widget.imageUrl, widget.userId));
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: widget.userId,
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                      onPressed: () {
                        UtilFunctions.makePhoneCall(widget.donorPhone, false);
                      },
                      icon: Icon(Icons.call)),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      UtilFunctions.openWhatsaap(widget.donorPhone);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(9),
                      child: Image.asset(
                        "images/whatsapp.png",
                        color: Colors.white,
                        height: 23,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 9,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  lableContainer(
                    label: "Donor Name",
                    fillText: widget.donorName,
                  ),
                  lableContainer(
                    label: "Patient Name",
                    fillText: widget.patientName,
                  ),
                  lableContainer(
                    label: "Donor UID",
                    fillText: widget.userId,
                  ),
                  lableContainer(
                    label: "Donated Time",
                    fillText: timeStampToDate(widget.timestamp),
                  ),
                  lableContainer(
                    label: "Units Donated",
                    fillText: widget.unitsDonated,
                  ),
                  lableContainer(
                    label: "Donated Type",
                    fillText: widget.donatedType,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          Dialogs.materialDialog(
                              barrierDismissible: false,
                              msg:
                                  'Are you sure ? you can\'t undo this\nUser will be credited with $donationPoints Life Points',
                              title: "Confirm Donation",
                              color: Colors.grey.shade900,
                              context: context,
                              actions: [
                                IconsOutlineButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text: 'Cancel',
                                  textStyle: TextStyle(color: Colors.grey),
                                  iconColor: Colors.grey,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Post")
                                        .doc(widget.postId)
                                        .update({
                                      'finalDonors':
                                          FieldValue.arrayUnion([widget.userId])
                                    });
                                    setToNotification(
                                        myName: "Helping Hands",
                                        uid: widget.userId,
                                        postId: widget.postId);

                                    Get.back();
                                  },
                                  text: 'Accept',
                                  iconData: Icons.done,
                                  color: Colors.greenAccent.shade400,
                                  textStyle: TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                              ]);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade400,
                          primary: Colors.greenAccent.shade400,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Accept',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () async {
                          Dialogs.materialDialog(
                              msg: 'Are you sure ? you can\'t undo this',
                              title: "Reject",
                              color: Colors.grey.shade900,
                              context: context,
                              actions: [
                                IconsOutlineButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text: 'Cancel',
                                  textStyle: TextStyle(color: Colors.grey),
                                  iconColor: Colors.grey,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Post")
                                        .doc(widget.postId)
                                        .update({
                                      'notDonors':
                                          FieldValue.arrayUnion([widget.userId])
                                    });
                                    Get.back();
                                  },
                                  text: 'Reject',
                                  iconData: Icons.cancel_outlined,
                                  color: Colors.red,
                                  textStyle: TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                              ]);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          primary: Colors.blueAccent,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Reject',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
