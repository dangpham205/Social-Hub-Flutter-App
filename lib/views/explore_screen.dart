import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endterm/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import '../constants/colors.dart';
import 'post_detail_screen.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({ Key? key }) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(6.0),
              top: Radius.circular(6.0)
            ),
            color: searchBox,
          ),
          child: Material(
            color: searchBox,
            child: InkWell(
              onTap: () {
                showSearch(context: context, delegate: SearchScreen());
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.search, size: 20, color: cwhite,),
                  Text('  Search', style: TextStyle(color: cwhite, fontSize: 14),)
                ],
              ),
            ),
          ),
        ),
      ),
      body:  
      FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder:(context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else{
            return StaggeredGridView.countBuilder(
              crossAxisCount: 3, 
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => 
                    InkWell(
                      child: Image.network(snapshot.data!.docs[index]['postUrl'], fit: BoxFit.cover,),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return PostDetailScreen(snap: snapshot.data!.docs[index].data());
                              }
                            ),
                            //  PostDetailScreen(snap: snapshot.data!.docs[index].data(),),
                          ),
                        ).then((value) {
                          setState(() {
                            
                          });
                        });
                      },
                    ),
              staggeredTileBuilder: (index) => StaggeredTile.count(
                (index % 7 == 0) ? 2 : 1,     //cross axis cells count
                (index % 7 == 0) ? 2 : 1,     //main axis cells count
              ),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            );
          }
        }
      ),
    );
  }
}