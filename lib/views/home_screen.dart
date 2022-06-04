import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/user.dart' as model;
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../widgets/post_card.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  model.User? user;
  List<dynamic> id = [];
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context).getUser;
    id = user!.following.toList();
    id.add(user!.uid);
    stream = FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', whereIn: id)
                  .orderBy('uploadDate', descending: true)
                  .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    
    // final model.User? user = Provider.of<UserProvider>(context).getUser; //lấy ra th user hiện tại
    // List<dynamic> id = user!.following.toList();
    // id.add(user.uid);

    return Scaffold(
      appBar: AppBar(                                   //app bar
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(                  //logo app
          'assets/logo.svg',
          color: logoColor,
          height: 50,
        ),
        actions: [
          IconButton(                                   //chat
              onPressed: () {},
              icon: const Icon(Icons.chat),
              color: cblack,
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: mobileBackgroundColor,
        onRefresh: ()async{
          return Future.delayed(const Duration(seconds: 1)).then((value) {
            
            setState(() {
              List<dynamic> id = user!.following.toList();
              id.add(user!.uid);
              stream = FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', whereIn: id)
                  .orderBy('uploadDate', descending: true)
                  .snapshots();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                ),
              ));
            });
          },);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
              StreamBuilder(
                stream: stream,                              //dùng stream để load ra các post
                // stream: FirebaseFirestore.instance
                //     .collection('posts')
                //     .where('uid', whereIn: id)
                //     .orderBy('uploadDate', descending: true)
                //     .snapshots(),
                //stream sẽ là các bài post, khi có các bài post mới đc add lên, stream builder sẽ build lại
                builder:(context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  //mặc định thì builder sẽ có snapshot
                  // cta sẽ định nghĩa snapshot ở đây là AsyncSnapshot vì sẽ build các post dựa vào realtime changes
                  // và kiểu của AsyncSnapshot này sẽ là QuerySnapshot của cloud_firestore chứa DocumentSnapshot
                  //và cta sẽ cast cái document (JSON obj) đó thành 1 Map (giống fromSnapShot trong file user và post.dart)
            
                  //nếu không định nghĩa loại snapshot cụ thể ở đây thì itemCount bên dưới sẽ kh lấy đc docs.length
                  //vì nó kh biết docs muốn lấy là docs async, kh thể lấy liền đc
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(color: cblack,),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty){         //nếu trong những người follow mà kh ai có post gì thì trả về empty
                    return Padding(
                      padding: const EdgeInsets.only(top: 128),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.heart_broken, size: 50, color: subText,),
                            Text("You don't have any posts yet", style: TextStyle(color: subText),),
                          ],
                        ),
                      ),
                    );
                  }
                  else{
                    return Column(
                      children: [
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,      //bắt buộc phải truyền vô
                          itemBuilder:(context, index) {
                            if( id.contains(snapshot.data!.docs[index]["uid"])){
                              return PostCard(
                                snap: snapshot.data!.docs[index].data(),    //truyền vô cái snap chứa thông tin của post đó, ****nơi xét follow???
                              );
                            }
                            else{
                              return const SizedBox.shrink();
                            }
                          }
                        ),
                        const Center(
                          child: Text('------------------------End------------------------', style: TextStyle(color: subText),),
                        ),
                        Container(
                          height: 8,
                          color: mobileBackgroundColor,
                        )
                      ],
                    );
                  }
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
}