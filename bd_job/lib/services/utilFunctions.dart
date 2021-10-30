import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class UtilFunctions {
  static String timeStampToDateTime(Timestamp timestamp) {
    String requiredDate;
    requiredDate = DateFormat('dd MMM yy, hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch));
    return requiredDate;
  }

  static Future<void> makePhoneCall(String contact, bool direct) async {
    if (direct == true) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = 'tel:$contact';

      if (await canLaunch(telScheme)) {
        await launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }

  static openWhatsaap(String phone) async {
    var whatsappUrl = "whatsapp://send?phone=" + phone + "&text=hello";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  // Future<String> getStateFromLocation(Position position) async {
  //   final coordinates = new Coordinates(position.latitude, position.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   return first.featureName;
  // }
}
