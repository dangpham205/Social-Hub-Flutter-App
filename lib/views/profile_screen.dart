import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endterm/views/follow_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../shared/firebase_firestore.dart';
import '../widgets/profile_button.dart';
import '../widgets/profile_drawer.dart';
import 'edit_profile_screen.dart';
import 'post_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool myProfile;
  const ProfileScreen({Key? key, required this.uid, required this.myProfile}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool openDiscover = false;

  // DocumentSnapshot? snapshot;
  // String? username,bio,avatarUrl;

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

    var postSnapShot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .get();
    postCount = postSnapShot.docs.length;
    followerCount = userSnapShot.data()!['followers'].length;
    followingCount = userSnapShot.data()!['following'].length;
    isFollowing = userSnapShot
        .data()!['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    if (mounted){
      setState(() {
        isLoading = false;
      });
    }

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(
            child: CircularProgressIndicator(),
          )
        :
        Scaffold(
            endDrawer: const ProfileDrawer() ,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                '@'+userData['username'].toString(),
                style: TextStyle(color: cblack),
              ),
              actions: [
                widget.myProfile == false
                ? IconButton(      //nếu mở trang profile không phải của bản thân (tức là đang vô xem profile ngkhac) thì cần cho phép pop để quay lại (ví dụ về màn home, search)
                  icon: Icon(Icons.close, color: cblack,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )  
                : IconButton(
                  icon: Icon(Icons.menu, color: cblack,),
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                ) 
              ],
            ),
            backgroundColor: mobileBackgroundColor,
            body: RefreshIndicator(
              onRefresh: () async{
                getUserData();
              },
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: darkColor,
                        backgroundImage: NetworkImage(userData['photoUrl'].toString()),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        userData['username'].toString(),
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cblack),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      userData['bio'].toString().isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 32, right: 32, bottom: 12),
                              child: Text(
                                userData['bio'].toString(),
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontWeight: FontWeight.w300, color: subText),
                              ),
                            )
                          : const SizedBox(
                              height: 16,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildProfileColumn('Posts', postCount),
                          const SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FollowScreen(uid: widget.uid, selectedTab: 0,)
                                ),
                              );
                            },
                            child: buildProfileColumn('Followers', followerCount)
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FollowScreen(uid: widget.uid, selectedTab: 1,)
                                ),
                              );
                            },
                            child: buildProfileColumn('Following', followingCount)
                          ),
                        ],
                      ),
                      const SizedBox( height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? ProfileButton(                    //nếu user truyền vô screen là current user (chính chủ) thì hiện nút edit profile
                              buttonColor: Colors.teal,
                              borderColor: Colors.white,
                              buttonText: 'EDIT PROFILE',
                              buttonTextColor: Colors.white,
                              function: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(uid: widget.uid),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    getUserData();
                                  });
                                });
                              },)
                          : isFollowing ? ProfileButton(      //nếu follow = true (đang follow) thì hiện nút unfollow
                                  buttonColor: Colors.grey,
                                  borderColor: Colors.white,
                                  buttonText: 'UNFOLLOW',
                                  buttonTextColor: Colors.white,
                                  function: () async {
                                    await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                                    setState(() {
                                      isFollowing = false;
                                      followerCount--;
                                    });
                                  },)
                          : ProfileButton(                          //còn không thì hiện nút follow
                              buttonColor: Colors.blueAccent,
                              borderColor: Colors.white,
                              buttonText: 'FOLLOW',
                              buttonTextColor: Colors.white,
                              function: () async {
                                await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                                setState(() {
                                  isFollowing = true;
                                  followerCount++;
                                });
                              },
                            ),
                          InkWell(
                            onTap: () {
                              openDiscover ? openDiscover = false : openDiscover = true;
                              setState(() {
                                
                              });   
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: openDiscover ? const Color.fromARGB(255, 217, 210, 210) : cwhite ,
                                border: Border.all(color: cblack),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.person_add, color: cblack,),
                              height: 36,
                            ),
                          )
                        ],
                      ),
                      const SizedBox( height: 16,),
                      openDiscover
                      ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('uid', whereNotIn: userData['following'])
                          .snapshots(includeMetadataChanges: true),
                        builder:(context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          return Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Expanded(
                                  child: Row(
                                    children: [
                                      Text(snapshot.data!.docs[index].data()['username'].toString()),
                                      Container(width: 6, color: mobileBackgroundColor2,)
                                    ],
                                  ),
                                );
                              }
                            ),
                          );
                        }
                      )
                      : const SizedBox.shrink(),
                      Container(
                        height: 4,
                        color: const Color.fromARGB(255, 244, 225, 225),
                      ),
                      StreamBuilder(                                  //hiển thị các post dưới dạng grid
                        stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .orderBy('uploadDate', descending: true)
                          .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          if (snapshot.data!.docs.isEmpty){         //nếu trong những người follow mà kh ai có post gì thì trả về empty
                            return Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.heart_broken, size: 50, color: subText,),
                                    Text("No posts yet", style: TextStyle(color: subText),),
                                  ],
                                ),
                              ),
                            );
                          }
                          else{
                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PostDetailScreen(snap: snapshot.data!.docs[index].data())
                                      ),
                                    );
                                  },
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(snapshot.data!.docs[index]
                                          .data()['postUrl']
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Column buildProfileColumn(String name, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 13, color: cblack),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          number.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cblack),
        )
      ],
    );
  }
}
