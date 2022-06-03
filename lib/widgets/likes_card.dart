import 'package:flutter/material.dart';
import '../constants/colors.dart';

class LikeCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const LikeCard({Key? key, required this.snap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print(snap);
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
          Expanded(
              child: Padding(
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cblack,
                          )),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: snap['bio'],
                          style: const TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: subText,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: TextButton(
              //  Follow người dùng
              onPressed: () {},
              child: const Text("Follow"),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 10, right: 10),
                backgroundColor: txtBtn,
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
