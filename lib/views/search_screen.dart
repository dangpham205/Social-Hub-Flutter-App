import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endterm/constants/colors.dart';
import 'package:endterm/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({ Key? key }) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: cblack,),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//     );
//   }
// }

class SearchScreen extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: mobileBackgroundColor,
      appBarTheme: AppBarTheme(
        titleSpacing: 0,
        color: mobileBackgroundColor, 
        elevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: searchBox,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: searchBox,
            width: 1.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        hintStyle: TextStyle(color: cwhite, fontSize: 14),
        iconColor: subText,
        constraints: const BoxConstraints(
          maxHeight: 38
        ),
        contentPadding: const EdgeInsets.only(bottom: 8, left: 12)
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: subText,),
        onPressed: () {
          FocusScope.of(context).unfocus();
          query = '';         //query la bien co san cua flutter, dung de chua gia tri nguoi dung nhap
        },
      ),
    ]; 
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: cblack,),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query.toLowerCase(),)
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
            itemCount: snapshot.data!.docs.length,     //sd kiểu này nếu không muốn cast type cho snapshot ở trên
            itemBuilder: (context, index){
              return InkWell(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: snapshot.data!.docs[index].data()['uid'],
                          myProfile: false,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.docs[index].data()['photoUrl'].toString()),
                  ),
                  title: Text(
                    snapshot.data!.docs[index].data()['username'].toString(),
                    style: TextStyle(color: cblack),
                  ),
                ),
              );
            }
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List id = [];
    final model.User? user = Provider.of<UserProvider>(context).getUser; //lấy ra th user hiện tại
    if (user!.following.isEmpty){
      id.add('default');
    }
    else{
      id = user.following;
    }

    return FutureBuilder(
      future: FirebaseFirestore.instance
        .collection('users')
        .where('uid', whereIn: id.length > 8 ? id.sublist(0,8) : id)
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
            itemCount: snapshot.data!.docs.length,     //sd kiểu này nếu không muốn cast type cho snapshot ở trên
            itemBuilder: (context, index){
              return InkWell(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: snapshot.data!.docs[index].data()['uid'],
                          myProfile: false,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.docs[index].data()['photoUrl'].toString()),
                  ),
                  title: Text(
                    snapshot.data!.docs[index].data()['username'].toString(),
                    style: TextStyle(color: cblack),
                  ),
                ),
              );
            }
          );
        }
      },
    );
  }

}