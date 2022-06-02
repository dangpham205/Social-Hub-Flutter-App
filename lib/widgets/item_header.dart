import 'package:flutter/material.dart';

import '../theme/colors.dart';


class ItemHeader extends StatelessWidget {
  const ItemHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "",
          style: TextStyle(
            color: white,
            fontSize: 25,
            fontWeight: FontWeight.w600
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
            child: Row(
              children: const  [
                Icon(Icons.camera_alt_outlined,color: Colors.black,),
                SizedBox(width: 5,),
                Text(
                  "Create",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
