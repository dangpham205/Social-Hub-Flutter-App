import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:endterm/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:endterm/views/signup_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    
            if (snapshot.connectionState == ConnectionState.waiting){
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