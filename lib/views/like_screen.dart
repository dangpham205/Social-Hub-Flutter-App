import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/comment_card.dart';
import '../widgets/like_card.dart';

class LikesScreen extends StatefulWidget {
  List<dynamic> items;
  final int likes;

  LikesScreen({Key? key, required this.items, required this.likes})
      : super(key: key);

  @override
  State<LikesScreen> createState() => _LikePostState();
}

class _LikePostState extends State<LikesScreen> {

  @override
  Widget build(BuildContext context) {
    widget.items.map((e) => print(e));
    print("Fuck ${widget.items}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Likes',
        ),
        centerTitle: false,
      ),
      // Display user comments
      body: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (ctx, index) =>
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.items[index].toString().trim())
                      .get(),
                  builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    var user = (snapshot.data);
                    print("user ${user?.data()}");
                    return LikeCard(snap: user?.data());
                  }
              )
      ),
    );
  }
}
