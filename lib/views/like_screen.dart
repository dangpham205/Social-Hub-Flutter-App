import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
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
    // widget.items.map((e) => print(e));
    // print("likes ${widget.items}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(      
          icon: const Icon(Icons.arrow_back, color: cblack,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Likes',
          style: TextStyle(color: cblack),
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
                  if(!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var user = (snapshot.data);
                    // print("user ${user?.data()}");

                    return LikeCard(snap: user?.data());
                  }
              )
      ),
    );
  }
}
