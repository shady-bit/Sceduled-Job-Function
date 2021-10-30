import 'package:flutter/material.dart';

class lableContainer extends StatelessWidget {
  final String label;
  final String? fillText;
  const lableContainer({Key? key, this.fillText, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            child: Text(
              label,
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
          Container(
            // height: 60.h,
            width: MediaQuery.of(context).size.width * 0.6,
            alignment: Alignment.centerLeft,
            child: Text(
              fillText!,
              style: TextStyle(
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
