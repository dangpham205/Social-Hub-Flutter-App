import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/utils.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';


class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeDisplaying = false; //mặc định thì like sẽ không hiển thị lên
  int numberOfComments = 0;
  bool postImageReady = false;
  String postImageUrl = '';
  var userData = {};
  String avatarUrl = '';
  String username = '';
  bool gettingUserData = false;
  


  @override
  void initState() {
    super.initState();
    getNumberOfComments();
    loadPostImages();
    getAvatarAndUsername();
  }

  void getNumberOfComments() async {

    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      numberOfComments = snapshot.docs.length;
    }
    catch(error){
      showSnackBar(context, error.toString());
    }
    if (mounted){
      setState(() {});
    }
  }

  void getAvatarAndUsername() async {
    setState(() {
      gettingUserData = true;
    });
    var userSnapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    userData = userSnapShot.data()!;

    avatarUrl = userData['photoUrl'].toString();
    username = userData['username'].toString();
    if (mounted){
    setState(() {
      gettingUserData = false;
    });
    }
  }

  void loadPostImages() async {
    setState(() {
      postImageReady = false;
    });
    postImageUrl = await widget.snap['postUrl'];
    setState(() {
        postImageReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser; //lấy ra th user hiện tại

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: gettingUserData ? const Center(child: CircularProgressIndicator(),)
      :
      Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(26.0)),
              color: darkColor,
            ),
            //container chứa avatar, tên ng dùng và dấu 3 chấm trên đầu bài viết
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)
                .copyWith(right: 0),
            child: InkWell(
              onTap: () {
                //này đi tới trang profile người post
              },
              child: Row(
                children: [
                  CircleAvatar(
                    //avatar
                    radius: 16,
                    backgroundColor: darkColor,
                    backgroundImage: NetworkImage(avatarUrl), //dùng snap lấy ra avatar của user
                  ),
                  Expanded(
                    //username
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username, //dùng snap lấy ra username
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.snap['uid'].toString() == user!.uid.toString() ? IconButton(
                    //3 chấm options
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8),
                            shrinkWrap: true,
                            children: [
                              
                              InkWell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16),
                                  child: const Text('Delete'),
                                ),
                                onTap: () async {
                                  // này để mở yes no dialog lên delete
                                },
                              ), 
                              InkWell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16),
                                  child: const Text('Cancel'),
                                ),
                                onTap: () async {
                                  Navigator.of(context).pop(); 
                                }
                              )
                            ]
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  ) : const SizedBox(),
                ],
              ),
            ),
          ),

          //image display
          GestureDetector(
            onDoubleTap: () async {
              // like khi double tap vô hình 
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.2),
                      bottom: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: postImageReady == false ?
                    const Center(child: Text('Waiting for internet connection', style: TextStyle(color: Colors.white),),)
                    : Image.network(
                      postImageUrl,
                      fit: BoxFit.fitWidth,
                    ), //dùng snap lấy url ảnh bài post
                  ),
                ),
                
              ],
            ),
          ),

          //like comment share
          Container(
            color: darkColor,
            child: Row(
              children: [
                IconButton(                   // NÚT LIKE NHỎ
                  onPressed: () {}, 
                  icon: const Icon(
                    Icons.thumb_up,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  //COMMENT
                  onPressed: () {
                    // đi tới trang comment
                  },
                  icon: const Icon(
                    Icons.comment,
                  ),
                ),
                IconButton(
                  //SEND
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
                Expanded(
                  child: Align(
                    //ARCHIVE
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark_border,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //CAPTION VÀ SỐ LIKE, NUMBER OF COMMENT
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26.0)),
              color: darkColor,
            ),
            padding: const EdgeInsets.only(left: 8,right: 8, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  //số like
                  '${widget.snap['likes'].length} likes',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Container(
                  //caption
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: username, //dùng snap lấy ra username
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const TextSpan(
                          text: "  ",
                        ),
                        TextSpan(
                          text: widget
                              .snap['description'], //dùng snap lấy ra caption
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // ĐI TỚI TRANG COMMENT
                  },
                  child: Container(
                    //VIEW COMMENTS
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all ${numberOfComments.toString()} comments',
                      style:
                          const TextStyle(fontSize: 14, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  //NGÀY POST
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['uploadDate'].toDate(),
                    ),
                    style: const TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
