import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? docsUpdated = 0;
  double? percent = 0.5;
  final _server = FirebaseFirestore.instance.collection("Post");
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  DateTime timestampToDate(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return date;
  }

  Future<void> checkPostIsExpired() async {
    int docCount = 0;
    //Getting all the posts whose requirement day is in past
    QuerySnapshot activePostList = await _server
        .where("bloodRequiredDateTime", isLessThan: DateTime.now())
        .where("expired", isEqualTo: false)
        .get();

    //Iterating through that posts
    for (var doc in activePostList.docs) {
      docCount++;
      print(doc.id);
      _server.doc(doc.id).update({
        "active": false,
        //making active: false
      }).then((value) {
        Map itemMap = doc.data() as Map;
        print("Data Got: ${itemMap["bloodRequiredDateTimeFirst"]} ${doc.id}");
        DateTime firstlyRequired =
            timestampToDate(itemMap["bloodRequiredDateTimeFirst"]);
        print("$firstlyRequired ${doc.id}");
        DateTime currentDateRequirement =
            timestampToDate(itemMap["bloodRequiredDateTime"]);

        print("After addition $firstlyRequired");
        if (firstlyRequired.add(Duration(days: 30)).isBefore(DateTime.now())) {
          print(doc.id + " is expired");
          _server.doc(doc.id).update({"expired": true});
        }
      });
    }

    setState(() {
      this.docsUpdated = docCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Scheduled Job Running"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Docs Updated",
                style: TextStyle(fontSize: 25),
              ),
              Text(
                docsUpdated.toString(),
                style: TextStyle(fontSize: 35),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: style,
                      onPressed: checkPostIsExpired,
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: const Text('Run')),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
