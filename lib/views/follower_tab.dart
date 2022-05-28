import 'package:flutter/material.dart';

import '../constants/colors.dart';

class FollowerTab extends StatefulWidget {
  const FollowerTab({ Key? key }) : super(key: key);

  @override
  State<FollowerTab> createState() => _FollowerTabState();
}

class _FollowerTabState extends State<FollowerTab> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearchResults = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mobileBackgroundColor2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12, bottom: 8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ThemeData().colorScheme.copyWith(
                    primary: cwhite,
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(color: cblack),
                  textInputAction: TextInputAction.search,
                  controller: _searchController,
                  decoration: InputDecoration(
                    fillColor: searchBox,
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: cwhite,
                    constraints: const BoxConstraints(
                      maxHeight: 42
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(
                        color: searchBox,
                        width: 1.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: cwhite),
                    contentPadding: const EdgeInsets.all(0),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: (){
                        _searchController.text = '';
                        FocusScope.of(context).unfocus();
                      },)
                  ),
                  cursorColor: cblack,
                  onFieldSubmitted: (String _) {      //khoong qtam String nhan dc la gi nen dat ten la _
                    setState(() {
                      showSearchResults = true;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}