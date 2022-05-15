import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';
import 'package:uuid/uuid.dart';

import 'firebase_storage.dart';
class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload Post
  Future<String> uploadPost(
      String uid,
      String description,
      Uint8List image,    //đây là file truyền vô để upload lên storage
      ) async {

    String res = 'Upload Failed';

    try{
      String photoUrl = await StorageMethods().uploadImgToStorage('postPics', image, true); //up ảnh bài post lên storage
      String postId = const Uuid().v1();

      Post post = Post(
          uid: uid,
          postId: postId,
          description: description,
          uploadDate: DateTime.now(),
          postUrl: photoUrl,
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJSON());    //up post lên firebase

      res = 'Upload Succeed';
    }
    catch(error){
      res = error.toString();
    }

    return res;
  }

}