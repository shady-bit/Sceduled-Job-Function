import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'widgets/donatedCard.dart';

class VerifiedRequest extends StatefulWidget {
  final String docId;
  const VerifiedRequest({Key? key, required this.docId}) : super(key: key);

  @override
  _VerifiedRequestState createState() => _VerifiedRequestState();
}

class _VerifiedRequestState extends State<VerifiedRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Post")
            .doc(widget.docId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("NoData");
          } else {
            List finalDonors = [];
            List<dynamic> donationRequestsList =
                snapshot.data!["donationRequest"];
            try {
              if (snapshot.data!["finalDonors"] != null) {
                finalDonors = snapshot.data!["finalDonors"];
              }
            } catch (e) {
              print(e);
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return buildDonatedCard(
                    snapshot.data!.id,
                    donationRequestsList[index],
                    snapshot.data!["patientName"],
                    finalDonors
                        .contains(donationRequestsList[index].keys.first));
              },
              itemCount: finalDonors.length,
            );
          }
        },
      ),
    );
  }

  Widget buildDonatedCard(
    String postId,
    Map<String, dynamic> a,
    String patientName,
    bool inFinalDonors,
  ) {
    String key = a.keys.first;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Profile")
            .doc(a.keys.first)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.data == null) {
            return Text("No Data");
          } else {
            return !inFinalDonors
                ? Container()
                : DonatedCard(
                    donorName: snapshot.data!["name"],
                    donorPhone: snapshot.data!["phone"],
                    postId: postId,
                    patientName: patientName,
                    imageUrl: a[key]["imageUrl"],
                    userId: key,
                    timestamp: a[key]["time"],
                    donatedType: a[key]["donated"],
                    unitsDonated: a[key]["donatedUnits"].toString(),
                  );
          }
        });
  }
}
