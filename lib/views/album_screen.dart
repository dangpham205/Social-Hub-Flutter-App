import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AlbumScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final albumImg;
  // ignore: prefer_typing_uninitialized_variables
  final albumName;

  const AlbumScreen({Key? key, required this.albumImg, required this.albumName})
      : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  bool isShowPlaying = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: cblack,
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
        backgroundColor: mobileBackgroundColor,
        title: Text(
          "Audio",
          style: TextStyle(color: cblack),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.send_outlined,
              color: cblack,
            ),
          ),
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: ListView(
          children: [
            const Divider(),
            //Album header
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  //Album img
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cwhite),
                      ),
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: NetworkImage(widget.albumImg),
                                  fit: BoxFit.cover)),
                        ),
                      )
                    ],
                  ),
                  //Album name
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Original Audio",
                          style: TextStyle(
                              color: cblack.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text("${widget.albumName}",
                            style: TextStyle(
                                color: cblack.withOpacity(0.7),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          "3 reels",
                          style: TextStyle(color: subText),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            //Save audio button
            Container(
              width: 10,
              margin: const EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: subText.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "Save audio",
                  style: TextStyle(
                      color: cblack.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      fontSize: 15),
                ),
              ),
            ),
            //Audio player
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: cblack,
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: size.width * 0.75,
                    child: Stack(
                      children: [
                        Container(
                          width: size.width * 0.75,
                          height: 2.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: subText.withOpacity(0.7)),
                        ),
                        Container(
                          width: size.width * 0.2,
                          height: 2.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: cblack),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "0:01",
                    style: TextStyle(
                      fontSize: 12,
                      color: cblack,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
            //Reels
            const SizedBox(
              height: 15,
            ),
            const Divider(),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('thumbnails')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      physics: const ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2.5,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          color: cblack,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                                imageUrl: snapshot.data.docs[index]
                                    ['video_img'],
                              ),
                              Positioned(
                                bottom: 5,
                                child: Row(
                                  children: [
                                    const Icon(Icons.play_arrow_outlined, size: 25),
                                    Text(
                                      snapshot.data.docs[index]['views'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
