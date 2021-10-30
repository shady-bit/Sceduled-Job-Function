import 'package:bd_job/notifier/notify.dart';
import 'package:bd_job/widgets/verifCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class PendingRequest extends StatefulWidget {
  final String docId;
  final int donationPoints;
  const PendingRequest(
      {Key? key, required this.docId, required this.donationPoints})
      : super(key: key);

  @override
  _PendingRequestState createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  @override
  void initState() {
    super.initState();
  }

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
            return Center(child: Text("NoData"));
          } else {
            // print(widget.docId);
            List finalDonors = [], noDonors = [];
            List<dynamic> donationRequestsList =
                snapshot.data!["donationRequest"];
            try {
              if (snapshot.data!["finalDonors"] != null) {
                finalDonors = snapshot.data!["finalDonors"];
              }
            } catch (e) {
              print(e);
            }

            try {
              if (snapshot.data!["notDonors"] != null) {
                noDonors = snapshot.data!["notDonors"];
              }
            } catch (e) {
              print(e);
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                return buildVerificationCard(
                    snapshot.data!.id,
                    donationRequestsList[index],
                    snapshot.data!["patientName"],
                    (finalDonors
                            .contains(donationRequestsList[index].keys.first) ||
                        noDonors
                            .contains(donationRequestsList[index].keys.first)));
              },
              itemCount: donationRequestsList.length,
            );
          }
        },
      ),
    );
  }

  Widget buildVerificationCard(String postId, Map<String, dynamic> a,
      String patientName, bool alreadyVerified) {
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
            return alreadyVerified
                ? Container()
                : VerifCard(
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
