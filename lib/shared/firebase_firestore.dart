import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_storage.dart';
import '../models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload Post
  Future<String> uploadPost(
    String uid,
    String description,
    Uint8List image, //đây là file truyền vô để upload lên storage
  ) async {
    String res = 'Upload Failed';

    try {
      String photoUrl = await StorageMethods().uploadImgToStorage(
          'postPics', image, true); //up ảnh bài post lên storage
      String postId = const Uuid().v1();

      Post post = Post(
          uid: uid,
          postId: postId,
          description: description,
          uploadDate: DateTime.now(),
          postUrl: photoUrl,
          likes: []);

      _firestore
          .collection('posts')
          .doc(postId)
          .set(post.toJSON()); //up post lên firebase

      res = 'Upload Succeed';
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      log(error.toString());
    }
  }
}
