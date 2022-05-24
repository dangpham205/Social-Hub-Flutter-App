
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';
import '../constants/utils.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../shared/firebase_auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });   

    String res = await AuthMethods().logIn(email: _emailController.text, password: _passwordController.text);
    if (res == 'Log In Succeed'){   //succeed thif chuyen sang trang main
      if (mounted){
        Navigator.of(context).pushAndRemoveUntil(    //nếu chỉ dùng push thì bấm back vẫn có thể quay lại screen trc
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                                                  webScreenLayout: WebScreenLayout(),
                                                  mobileScreenLayout: MobileScreenLayout(),
                                                ),
          ),
          (route) => false
        );
      }
    }
    else{
      showSnackBar(context, res);
    }
    if(mounted){
      setState(() {
        _isLoading = false;
      }); 
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();      //very important
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Flexible(child: Container(), flex: 2,),
                SvgPicture.asset('assets/logo.svg', color: logoColor, height: 70,),   //logo
                const SizedBox(height: 64,),
                UserEmail(emailController: _emailController),
                const SizedBox(height: 28,),
                UserPassword(passwordController: _passwordController),
                const SizedBox(height: 28,),
                InkWell(                        //button login
                  onTap: loginUser,
                  child: Container(        
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: cwhite,
                          )
                        : const Text('LOG IN', style: TextStyle(fontWeight: FontWeight.bold)),
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
                Flexible(child: Container(), flex: 2,),
                Row(                    //text de chuyen sang sign up screen
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text("Don't have an account?", style: TextStyle(color: subText,)),
                    const SizedBox(width: 10,),
                    InkWell(
                      onTap: navigateToSignUp,
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: cblack,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 22,),
              ],
            ),
          )),
        ),
      ),
    );
  }
}


class UserPassword extends StatelessWidget {
  const UserPassword({
    Key? key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController, super(key: key);

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: cblack),
      textInputAction: TextInputAction.go,
      controller: _passwordController,
      decoration: const InputDecoration(
        label: Text('Password'),
        labelStyle: TextStyle(fontSize: 14, color: Colors.purple, fontWeight: FontWeight.bold),
        hintText: 'Enter Password',
        focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 1.0),
            ),
        enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
      ),
      keyboardType: TextInputType.text,
      obscureText: true
    );
  }
}

class UserEmail extends StatelessWidget {
  const UserEmail({
    Key? key,
    required TextEditingController emailController,
  }) : _emailController = emailController, super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: cblack),
      textInputAction: TextInputAction.next,
      controller: _emailController,
      decoration: const InputDecoration(
        label: Text('Email'),
        labelStyle: TextStyle(fontSize: 14, color: Colors.purple, fontWeight: FontWeight.bold),
        hintText: 'Enter Email',
        focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 1.0),
            ),
        enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}