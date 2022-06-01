import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/video_player_item.dart';


class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   _tabController = TabController(length: 3, vsync: this);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          _tabController = TabController(length: snapshot.data.docs.length, vsync: this);
          return TabBarView(
            controller: _tabController,
            children: List.generate(snapshot.data.docs.length, (index) {
              return VideoPlayerItem(
                videoUrl: snapshot.data.docs[index]['videoUrl'],
                size: size,
                name: snapshot.data.docs[index]['name'],
                caption: snapshot.data.docs[index]['caption'],
                songName: snapshot.data.docs[index]['songName'],
                profileImg: snapshot.data.docs[index]['profileImg'],
                likes: snapshot.data.docs[index]['likes'],
                comments: snapshot.data.docs[index]['comments'],
                shares: snapshot.data.docs[index]['shares'],
                albumImg: snapshot.data.docs[index]['albumImg'],
              );
            }),
          );
        },
      ),
    );
  }
}




