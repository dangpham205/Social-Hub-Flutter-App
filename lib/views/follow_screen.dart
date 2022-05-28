import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endterm/views/follower_tab.dart';
import 'package:endterm/views/following_tab.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class FollowScreen extends StatefulWidget {
  final String uid;
  final int selectedTab;
  const FollowScreen({ Key? key, required this.uid, required this.selectedTab }) : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {

  var userData = {};
  int followerCount = 0;
  int followingCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    setState(() {
      isLoading = true;
    });
   
    var userSnapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    userData = userSnapShot.data()!;
    
    followerCount = userSnapShot.data()!['followers'].length;
    followingCount = userSnapShot.data()!['following'].length;

    if (mounted){
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.selectedTab,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            '@'+userData['username'].toString(),
            style: const TextStyle(color: cblack),
          ),
          leading: IconButton(      //nếu mở trang profile không phải của bản thân (tức là đang vô xem profile ngkhac) thì cần cho phép pop để quay lại (ví dụ về màn home, search)
            icon: const Icon(Icons.arrow_back, color: cblack,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: TabBar(
            indicatorColor: dividerColor,
            tabs: [
              Tab(
                child: Text(followerCount.toString()+' followers', style: const TextStyle(color: Colors.black),),
              ),
              Tab(
                child: Text(followingCount.toString()+' following', style: const TextStyle(color: Colors.black),),
              ),              
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            FollowerTab(),
            FollowingTab(),
          ]
        ),
      ),
    );
  }
}