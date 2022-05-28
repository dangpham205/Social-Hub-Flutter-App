import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endterm/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';
import 'follow_screen.dart';
import 'profile_screen.dart';

class FollowingTab extends StatefulWidget {
  const FollowingTab({ Key? key }) : super(key: key);

  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<FollowingTab> {

  final TextEditingController _searchController = TextEditingController();
  bool showSearchResults = false;
  model.User? user;
  List<dynamic> id = [];
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context).getUser;
    id = user!.following.toList();
    if (id.isEmpty){
      id.add('default');
    }
    print('alo 1' + id.toString());
    stream = FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', whereIn: id)
                  .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: RefreshIndicator(
        displacement: 0,
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 1)).then((value) {
            setState(() {
              id = user!.following.toList();
              if (id.isEmpty){
                id.add('default');
              }
              print('alo' + id.toString());
              stream = FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', whereIn: id)
                  .snapshots();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>  FollowScreen(uid: user!.uid, selectedTab: 1,)
              ));
            });
          },);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox.fromSize(
            size: MediaQuery.of(context).size,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: mobileBackgroundColor2,
                  padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12, bottom: 8),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ThemeData().colorScheme.copyWith(
                        primary: cwhite,
                      ),
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: cblack),
                      textInputAction: TextInputAction.search,
                      controller: _searchController,
                      decoration: InputDecoration(
                        fillColor: searchBox,
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        prefixIconColor: cwhite,
                        constraints: const BoxConstraints(
                          maxHeight: 42
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(
                            color: searchBox,
                            width: 1.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: cwhite),
                        contentPadding: const EdgeInsets.all(0),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: (){
                            _searchController.text = '';
                            FocusScope.of(context).unfocus();
                            setState(() {
                              showSearchResults = false;
                            });
                          },)
                      ),
                      cursorColor: cblack,
                      onFieldSubmitted: (String _) {      //khoong qtam String nhan dc la gi nen dat ten la _
                        setState(() {
                          showSearchResults = true;
                        });
                      },
                    ),
                  ),
                ),
                showSearchResults 
                ? FutureBuilder(        // hiện kqua search
                  future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: _searchController.text,)
                    .get(), 
                  //get the collections, data cua users
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else{
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,     //sd kiểu này nếu không muốn cast type cho snapshot ở trên
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: snapshot.data!.docs[index].data()['uid'], myProfile: false,
                                ),
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data!.docs[index].data()['photoUrl'].toString()),
                              ),
                              title: Text(
                                snapshot.data!.docs[index].data()['username'].toString(),
                                style: const TextStyle(color: cblack),
                              ),
                            ),
                          );
                        }
                      );
                    }
                  },
                )
                : StreamBuilder(                //mặc định thì hiện hết tất cả following ra
                  stream: stream,
                      //get the collections, data cua users
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(),
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
                              Text("You have not followed anyone yet", style: TextStyle(color: subText),),
                            ],
                          ),
                        ),
                      );
                    }
                    else{
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,     //sd kiểu này nếu không muốn cast type cho snapshot ở trên
                        itemBuilder: (context, index){
                          if( id.contains(snapshot.data!.docs[index].data()["uid"])){
                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: snapshot.data!.docs[index].data()['uid'], myProfile: false,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!.docs[index].data()['photoUrl'].toString()),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index].data()['username'].toString(),
                                  style: const TextStyle(color: cblack,)
                                ),
                              ),
                            );
                          }
                          else{
                            return const SizedBox.shrink();
                          }
                        }
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}