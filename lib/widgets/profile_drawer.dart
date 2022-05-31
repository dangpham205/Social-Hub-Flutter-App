import 'package:endterm/views/about_us_screen.dart';
import 'package:endterm/widgets/yes_no_dialog.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../shared/firebase_auth.dart';
import '../views/login_screen.dart';
import '../views/settings_screen.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({ Key? key }) : super(key: key);

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: mobileBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          children: [
            const SizedBox(height: 48,),
            drawerItem(
              text: 'Settings',
              textColor: cblack,
              icon: Icons.settings,
              function: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
            ),
            drawerItem(
              text: 'Saved',
              textColor: cblack,
              icon: Icons.bookmark,
              function: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              }
            ),
            drawerItem(
              text: 'About us',
              textColor: cblack,
              icon: Icons.info_outline_rounded,
              function: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ));
              }
            ),
            const Divider(color: dividerColor,),
            drawerItem(
              text: 'Log Out',
              textColor: cblack,
              icon: Icons.logout,
              function: () async {
                showDialog(context: context, builder: (context) => YesNoDialog(
                  function: () async {
                    await AuthMethods().signOut();
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  title: 'Log Out', 
                  content: 'Do you really want to log out? :('));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget drawerItem(
  {
    required String text,
    required IconData icon,
    required Color textColor,
    VoidCallback? function,
  }) {
    

    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(text, style: TextStyle(color: textColor),),
      onTap:function,
    );
  }
}