import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class FullScreenPhoto extends StatelessWidget {
  final String donationPic;
  final String userId;
  FullScreenPhoto(this.donationPic, this.userId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: PinchZoom(
              child: Hero(
                tag: userId,
                child: Image.network(donationPic),
              ),
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 2.5,
              onZoomStart: () {
                print('Start zooming');
              },
              onZoomEnd: () {
                print('Stop zooming');
              },
            ),
          ),
          Positioned(
            left: 10,
            top: 40,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                }),
          )
        ],
      ),
    );
    // );
  }
}
