import 'package:endterm/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _value = false;
  bool _temp = false;

  @override
  void initState() {
    super.initState();
    darkMode();
  }

  Future darkMode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isCurrentDarkMode = prefs.getBool('darkMode');
    if (isCurrentDarkMode == true){
      _value = true;
    }
    else{
      _value = false;
    }
    _temp = _value;
    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logoColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if( _value != _temp){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                ),
              ),(route) => false
              );
            }
            else{
              Navigator.of(context).pop();        //phải pop 2 lần (1 lần quay lại màn profile, 1 lần đóng cái drawer)
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text('Settings'),
        titleSpacing: 0,
      ),
      backgroundColor: mobileBackgroundColor,
      body: Container(
      color: optionColor,
      padding: const EdgeInsets.only(top: 8,bottom: 8, right: 6, left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.dark_mode, color: cblack,),
          const SizedBox(width: 16,),
          Expanded(child: Text('Dark mode', style: TextStyle(fontWeight: FontWeight.bold, color:cblack),)),
          CupertinoSwitch(
            value: _value,
            onChanged: (newValue) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              _value = newValue;
              prefs.setBool('darkMode', _value);
              setState(
                () {
                  if(_value == true){
                    mobileBackgroundColor = Colors.black;
                    mobileBackgroundColor2 = Colors.black;
                    cblack = Colors.white;
                    cwhite = Colors.black;
                    optionColor = Colors.grey;
                    postCardBg = const Color.fromARGB(255, 209, 204, 204);
                  }
                  else{
                    mobileBackgroundColor = Colors.white;
                    mobileBackgroundColor2 = const Color.fromARGB(255, 244, 225, 225);
                    cwhite = Colors.white;
                    cblack = Colors.black;
                    optionColor = Colors.white;
                    postCardBg = const Color.fromARGB(255, 245, 184, 184);
                  }
                }
              );
            }
          )
        ],
      ),
    )
    );
  }
}