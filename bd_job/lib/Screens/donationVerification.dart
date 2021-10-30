import 'package:bd_job/services/utilFunctions.dart';
import 'package:bd_job/widgets/labelContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'allPostRequests.dart';

class DonationVerification extends StatefulWidget {
  const DonationVerification({Key? key}) : super(key: key);

  @override
  _DonationVerificationState createState() => _DonationVerificationState();
}

class _DonationVerificationState extends State<DonationVerification> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Post for verification"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Post")
              .where("donationRequest", isNotEqualTo: false)
              .orderBy("bloodRequiredDateTime")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'No Data...',
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    // print("Donation Request: ${data["donationRequest"][0]}");
                    // print("Final Donors: ${data["finalDonors"]}");
                    return PostCardMeta(
                      data: data,
                      docId: document.id,
                    );
                  }).toList(),
                ),
              );
            }
          }),
    );
  }
}

class PostCardMeta extends StatelessWidget {
  final String docId;
  const PostCardMeta({
    required this.docId,
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Profile")
          .doc(data["createdBy"])
          .get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularPercentIndicator(radius: 20),
          );
        } else {
          return GestureDetector(
            onTap: () {
              Get.to(() => AllPostRequests(
                    postedName: snapshot.data["name"],
                    docId: docId,
                    phone: snapshot.data["phone"],
                  ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Wrap(
                children: [
                  lableContainer(
                    label: "Patient Name",
                    fillText: data["patientName"],
                  ),
                  lableContainer(
                    label: "City Name",
                    fillText: data["hospitalCity"],
                  ),
                  lableContainer(
                    label: "Required By",
                    fillText: UtilFunctions.timeStampToDateTime(
                        data["bloodRequiredDateTimeFirst"]),
                  ),
                  lableContainer(
                    label: "Posted By",
                    fillText: snapshot.data["name"],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Text(
                            "Hospital Address",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        FittedBox(
                          fit: BoxFit.fill,
                          child: Container(
                            // height: 60.h,
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data["hospitalAddr"],
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// Get.to(() => AllPostRequests(docId: document.id));
