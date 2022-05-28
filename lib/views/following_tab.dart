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

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final model.User? user = Provider.of<UserProvider>(context).getUser; //lấy ra th user hiện tại
    
    return Scaffold(
      body: Container(
        color: mobileBackgroundColor2,
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          onRefresh: () async {
            return Future.delayed(const Duration(seconds: 1)).then((value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>  FollowScreen(uid: user!.uid, selectedTab: 1,)
              ));
            },);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
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
              : user!.following.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 128),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.heart_broken, size: 50, color: subText,),
                      Text("You have not followed anyone yet.", style: TextStyle(color: subText),),
                    ],
                  ),
                ),
              )
              : StreamBuilder(                //mặc định thì hiện hết tất cả following ra
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', whereIn: user.following)
                    .snapshots(), 
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
                              style: const TextStyle(color: cblack,)
                            ),
                          ),
                        );
                      }
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}