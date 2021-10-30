import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/rejectedCard.dart';

class RejectedRequest extends StatefulWidget {
  final String docId;
  const RejectedRequest({Key? key, required this.docId}) : super(key: key);

  @override
  _RejectedRequestState createState() => _RejectedRequestState();
}

class _RejectedRequestState extends State<RejectedRequest> {
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
            List notDonors = [];
            List<dynamic> donationRequestsList =
                snapshot.data!["donationRequest"];
            try {
              if (snapshot.data!["notDonors"] != null) {
                notDonors = snapshot.data!["notDonors"];
              }
            } catch (e) {
              print(e);
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return buildRejectedCard(
                    snapshot.data!.id,
                    donationRequestsList[index],
                    snapshot.data!["patientName"],
                    notDonors.contains(donationRequestsList[index].keys.first));
              },
              itemCount: notDonors.length,
            );
          }
        },
      ),
    );
  }

  Widget buildRejectedCard(
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
          } else {
            return !inFinalDonors
                ? Container()
                : RejectedCard(
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
