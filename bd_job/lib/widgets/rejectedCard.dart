import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fullPagePhoto.dart';
import 'labelContainer.dart';

class RejectedCard extends StatefulWidget {
  final String donorPhone;
  final String donorName;
  final String postId;
  final String imageUrl;
  final String userId;
  final Timestamp timestamp;
  final String donatedType;
  final String unitsDonated;
  final String patientName;
  const RejectedCard(
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
  _RejectedCardState createState() => _RejectedCardState();
}

class _RejectedCardState extends State<RejectedCard> {
  late int donationPoints;

  String timeStampToDate(Timestamp timestamp) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    final DateFormat serverFormatter = DateFormat('yMMMMd');
    final String formatted = serverFormatter.format(date);
    return formatted.toString();
  }

  void openWhatsaap(String phone) async {
    var whatsappUrl = "whatsapp://send?phone=$phone";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 15, 8, 0),
      child: Wrap(
        children: [
          Column(
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
                  IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      openWhatsaap(widget.donorPhone);
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
                height: 15,
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
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Rejected")
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
