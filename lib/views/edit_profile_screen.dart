import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../constants/utils.dart';
import '../shared/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  const EditProfileScreen({ Key? key, required this.uid }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  var userData = {};
  bool isLoading = false;
  bool _isUpdating = false;
  Uint8List? _avatar;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  String userEmail = '';
  String userName = '';
  String userBio = '';


  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();      //very important
    _bioController.dispose();
  }

  void selectAvatar() async {
    try{        //trường hợp: người dùng bấm chọn ảnh mà cancel không chọn nữa ==> không thể cast null cho Uint8list
      Uint8List img =  await pickImage(ImageSource.gallery);
      setState(() {
        _avatar = img;
      });
    }
    catch (error){
      return;
    }
  }

  getUserData() async {                                         //LẤY USERDATA TỪ UID TRUYỀN VÔ
    setState(() {
      isLoading = true;
    });
    var userSnapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    userData = userSnapShot.data()!;
    userEmail = userData['email'].toString();
    userName = userData['username'].toString();
    userBio = userData['bio'].toString();
    _usernameController = TextEditingController(text: userName);
    _bioController = TextEditingController(text: userBio);

    setState(() {
      isLoading = false;
    });
  }

  void updateUser() async {                                   // khi bấm vào nút UPDATE
    setState(() {
        _isUpdating = true;
      });  

      String res = await AuthMethods().updateProfile(
        uid: widget.uid,
        username: _usernameController.text,
        bio: _bioController.text ,
        oldAvatar: userData['photoUrl'].toString(),
        image: _avatar);
      if (res != 'Update Succeed'){
        showSnackBar(context, res);
      }
      else{
        Navigator.of(context).pop();
      }

      setState(() {
        _isUpdating = false;
      }); 
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(
      child: CircularProgressIndicator(),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 1,
        leading: IconButton(      
          icon: Icon(Icons.arrow_back, color: cblack,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Update Profile', style: TextStyle(color: cblack),),
      ),
      backgroundColor: mobileBackgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,   //return width cua man hinh
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,    //center tat ca children theo chieu truc cross ==> chieu ngang
                  children: [
                    Flexible(child: Container(), flex: 0,),
                    const SizedBox(height: 18,),
                    Stack(
                      children:  [
                        _avatar != null ?     //nếu image khác null thì hiện image đó lên
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_avatar!),
                        )
                            : CircleAvatar(   //còn không thì hiện avt mặc định
                          radius: 64,
                          backgroundImage: NetworkImage(userData['photoUrl'].toString()),
                        ),   //avatar mặc định
                        Positioned(     //nút thêm ảnh avatar
                          bottom: -6,
                          left: 80,
                          child: IconButton(
                            onPressed: selectAvatar,
                            icon: const Icon(Icons.add_a_photo),
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 28,),
                    UserEmail(userEmail: userEmail),
                    const SizedBox(height: 28,),
                    UserName(usernameController: _usernameController),
                    const SizedBox(height: 28,),
                    UserBio(passwordController: _bioController),
                    const SizedBox(height: 28,),
                    InkWell(                        //button login
                      onTap: updateUser,      //gọi hàm update profile
                      child: Container(
                        child: _isUpdating
                            ? const Center(         //nếu mà bấm update thì sẽ hiện vòng load
                          child: CircularProgressIndicator(color: Colors.white,),
                        )
                            : const Text('UPDATE', style: TextStyle(fontWeight: FontWeight.bold),),  //update xong thì sẽ quay lại hiện chữ trong button
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 46,
                        decoration: const ShapeDecoration(
                          color: loginButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28,),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class UserEmail extends StatelessWidget {
  const UserEmail({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.grey),
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        label: Text('Email'),
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      enabled: false,
      initialValue: userEmail,
    );
  }
}

class UserBio extends StatelessWidget {
  const UserBio({
    Key? key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController, super(key: key);

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: cblack),
      textInputAction: TextInputAction.go,
      controller: _passwordController,
      decoration: const InputDecoration(
        label: Text('Bio'),
        labelStyle: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold),
        hintText: 'Enter Username',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}

class UserName extends StatelessWidget {
  const UserName({
    Key? key,
    required TextEditingController usernameController,
  }) : _usernameController = usernameController, super(key: key);

  final TextEditingController _usernameController;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: cblack),
      textInputAction: TextInputAction.next,
      controller: _usernameController,
      decoration: const InputDecoration(
        label: Text('Username'),
        labelStyle: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold),
        hintText: 'Enter Username',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}