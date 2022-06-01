import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'column_social_icon.dart';


class LeftPanel extends StatelessWidget {
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  const LeftPanel({
    Key? key,
    required this.size,
    required this.name,
    required this.caption,
    required this.songName, required this.profileImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              getProfile(profileImg),
              SizedBox(width: 10,),
              Text(
                name,
                style: TextStyle(
                    color: white, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(width: 10,),
              Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.white.withOpacity(0.5))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text("Follow",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 0.5),),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            caption,
            style: TextStyle(color: white),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.music_note,
                color: white,
                size: 15,
              ),
              Flexible(
                child: Text(
                  songName,
                  style: TextStyle(color: white, height: 1.5),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}