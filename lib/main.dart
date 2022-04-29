import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:endterm/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:endterm/views/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions( //lúc tạo web app trên firebase sẽ đc cung cấp cái này
            apiKey: "AIzaSyCVX1-5K7ehw5aZrE2Gv1F-rv44f5HNgJs",
            authDomain: "instagram-flutter-7c654.firebaseapp.com",
            projectId: "instagram-flutter-7c654",
            storageBucket: "instagram-flutter-7c654.appspot.com",
            messagingSenderId: "368117043222",
            appId: "1:368117043222:web:6f1b3c2898c64c0ce62537"
        ));
        }
        else{
    await Firebase.initializeApp();
    }
        runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SocialHub',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        //userChanges() thì sẽ được gọi mỗi khi user sign in, sign out,thay nổi password,email, ...
        //idTokenChanges() thì sẽ được gọi mỗi khi user sign in, sign out,... điểm trừ là nếu ng dùng cài app đó
        //lên máy khác(apk) thì app đó sẽ ghi nhớ luôn phiên đăng nhập trong máy trước
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white,),
            );
          }

          return const SignUpScreen();
        },
      ),
    );
  }
}

// // Import the functions you need from the SDKs you need
// import { initializeApp } from "firebase/app";
// // TODO: Add SDKs for Firebase products that you want to use
// // https://firebase.google.com/docs/web/setup#available-libraries

// // Your web app's Firebase configuration
// const firebaseConfig = {
//   apiKey: "AIzaSyBpgYdaQULiNgONN1JGkFko6eP9wmDSCpI",
//   authDomain: "endterm-group9.firebaseapp.com",
//   projectId: "endterm-group9",
//   storageBucket: "endterm-group9.appspot.com",
//   messagingSenderId: "564771532215",
//   appId: "1:564771532215:web:2f43d41be689dcbee70c32"
// };

// // Initialize Firebase
// const app = initializeApp(firebaseConfig);