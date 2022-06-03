import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../constants/colors.dart';

class AlbumScreen extends StatefulWidget {
  final albumImg;
  final albumName;

  const AlbumScreen({Key? key, required this.albumImg, required this.albumName})
      : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  late VideoPlayerController _videoController;
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
          Icon(
            Icons.send_outlined,
            color: cblack,
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Divider(),
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
                            color: Colors.white),
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
                        SizedBox(
                          height: 12,
                        ),
                        Text("${widget.albumName}",
                            style: TextStyle(
                                color: cblack.withOpacity(0.7),
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
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
              margin: EdgeInsets.only(left: 10, right: 10),
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
            SizedBox(
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
            SizedBox(
              height: 15,
            ),
            Divider(),
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
                      physics: ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2.5,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.black,
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
                                    Icon(Icons.play_arrow_outlined, size: 25),
                                    Text(
                                      snapshot.data.docs[index]['views'],
                                      style: TextStyle(
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
