import 'package:bd_job/widgets/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'inputDecoration.dart';

class ChangeVariables extends StatefulWidget {
  const ChangeVariables({Key? key}) : super(key: key);

  @override
  _ChangeVariablesState createState() => _ChangeVariablesState();
}

class _ChangeVariablesState extends State<ChangeVariables> {
  TextEditingController _refferalController = new TextEditingController();
  TextEditingController _donationPointsController = new TextEditingController();
  TextEditingController _checkRadiusController = new TextEditingController();
  TextEditingController _bloodToBloodFController = new TextEditingController();
  TextEditingController _bloodToBloodMController = new TextEditingController();
  TextEditingController bloodToPlasmaController = new TextEditingController();
  TextEditingController _bloodToPlateletsController =
      new TextEditingController();
  TextEditingController _plasmaToPlasmaController = new TextEditingController();
  TextEditingController _plasmaToPlateletsController =
      new TextEditingController();
  TextEditingController _plateletsToBloodController =
      new TextEditingController();
  TextEditingController _plateletsToPlasmaController =
      new TextEditingController();

  final Stream<DocumentSnapshot> varStream = FirebaseFirestore.instance
      .collection('values')
      .doc("referralLifePoints")
      .snapshots();

  Widget variableWidget({String? lable, TextEditingController? controller}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      // height: 100,
      // color: Colors.blue,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(lable.toString()),
              Container(
                width: 100,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: CustomInputDecoration.buildInputDecoration(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Constant Variables"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: StreamBuilder<DocumentSnapshot>(
            stream: varStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              if (snapshot.hasData) {
                DocumentSnapshot? data = snapshot.data;
                print(data);
              }
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    variableWidget(
                        lable: "Refferal Points",
                        controller: _refferalController),
                    variableWidget(
                        lable: "Donation Points",
                        controller: _donationPointsController),
                    variableWidget(
                        lable: "Check Radius",
                        controller: _checkRadiusController),
                    variableWidget(
                        lable: "BloodToBloodF",
                        controller: _bloodToBloodFController),
                    variableWidget(
                        lable: "BloodToBloodM",
                        controller: _bloodToBloodMController),
                    variableWidget(
                        lable: "BloodToPlasma",
                        controller: bloodToPlasmaController),
                    variableWidget(
                        lable: "BloodToPlatelets",
                        controller: _bloodToPlateletsController),
                    variableWidget(
                        lable: "PlasmaToPlasma",
                        controller: _plasmaToPlasmaController),
                    variableWidget(
                        lable: "PlasmaToPlatelets",
                        controller: _plasmaToPlateletsController),
                    variableWidget(
                        lable: "PlateletsToBlood",
                        controller: _plateletsToBloodController),
                    variableWidget(
                        lable: "PlateletsToPlasma",
                        controller: _plateletsToPlasmaController),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              );
            },
          )),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomButton(),
          )
        ],
      ),
    );
  }
}
