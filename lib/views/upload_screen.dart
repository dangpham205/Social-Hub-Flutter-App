import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/utils.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../shared/firebase_firestore.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({ Key? key }) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  
  Uint8List? image;
  Uint8List? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  User? user;


  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: const Text('Upload Media'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(12),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              try{
                image = await pickImage(ImageSource.camera);
              }
              catch (error){
                image = null;
              }
              setState(() {
                if( image != null){
                  _image = image;
                }
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(12),
            child: const Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              try{
                image = await pickImage(ImageSource.gallery);
              }
              catch (error){
                image = null;
              }
              setState(() {
                if (image != null){
                  _image = image;
                }
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(12),
            child: const Text('Cancel'),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  void uploadPost(
      String uid,
      String username,
      String avatarUrl,
      ) async {
    setState(() {
      _isLoading = true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(
        uid,
        _descriptionController.text,
        _image!,
      );

      if (res == 'Upload Succeed'){
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
        clearScreen();
      }
      else{
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    }
    catch(error){
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, error.toString());
    }
  }

  void clearScreen(){
    setState(() {
      _image = null;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      user = Provider.of<UserProvider>(context).getUser;      //get thằng user hiện tại ra
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return _image == null 
    ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: mobileBackgroundColor,
      child: Center(
        child: IconButton(
          iconSize: 50,
          icon: Icon(Icons.upload, color: cblack,),
          onPressed: () => _selectImage(context),
        ),
      ),
    ) 
    : SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            leading: IconButton(
              onPressed: clearScreen,
              icon: const Icon(Icons.arrow_back),
              color: cblack,
            ),
            title: Text('Upload Post', style: TextStyle(color: cblack),),
            actions: [                //nút Post
              TextButton(
                onPressed: () => uploadPost( user!.uid, user!.username, user!.photoUrl),
                child: const Text(
                  'POST', 
                  style: TextStyle(
                    color: txtBtn, 
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: mobileBackgroundColor,
          body: Column(
            children: [
              _isLoading ? const LinearProgressIndicator() : Container(),   //show indicator khi bấm nút POST
              Divider(color: mobileBackgroundColor,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cblack,
                    backgroundImage: NetworkImage(
                      user!.photoUrl,
                    ),   
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: TextField(
                      style: TextStyle(color: cblack),
                      textInputAction: TextInputAction.newline,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: TextStyle(color: subText),
                        border: InputBorder.none,
                      ),
                      maxLines: 10,
                    ),
                  ),
                ],
              ),
              const Divider(color: dividerColor,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.5,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      color: darkColor,
                      image: DecorationImage(
                        image: MemoryImage(_image!),
                        fit: BoxFit.contain,
                        alignment: FractionalOffset.topCenter
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}