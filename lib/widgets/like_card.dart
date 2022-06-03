import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/colors.dart';

class LikeCard extends StatelessWidget {
  final snap;
  const LikeCard({Key? key,required this.snap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(snap);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap['photoUrl'],
            ),
            radius: 18,
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                      ),
                    ],
                  ),
                ),
                Text(snap['bio'], style: const TextStyle(fontWeight: FontWeight.w400,color: Colors.grey)
                )
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: TextButton(
              // TODO: Follow người dùng
              onPressed: () {},
              child: Text("Follow"),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 10, right: 10),
                backgroundColor: secondary,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
