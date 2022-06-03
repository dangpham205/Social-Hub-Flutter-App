import 'package:endterm/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _value = false;

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
            Navigator.of(context).pop();        //phải pop 2 lần (1 lần quay lại màn profile, 1 lần đóng cái drawer)
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings'),
        titleSpacing: 0,
      ),
      body: Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8,bottom: 8, right: 6, left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.dark_mode, color: cblack,),
          const SizedBox(width: 16,),
          const Expanded(child: Text('Dark mode', style: TextStyle(fontWeight: FontWeight.bold, color:Colors.black),)),
          CupertinoSwitch(
            value: _value,
            onChanged: (newValue) {
              setState(
                () async{
                  _value = newValue;
                  // prefs.setBool('darkMode', _value);
                  // if(_value == true){
                  //   print("vaaa"+_value.toString());
                  //   mobileBackgroundColor = Colors.black;
                  //   cblack = Colors.white;
                  //   cwhite = Colors.black;
                  // }
                  // else{
                  //   mobileBackgroundColor = Colors.white;
                  //   cwhite = Colors.white;
                  //   cblack = Colors.black;
                  // }
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