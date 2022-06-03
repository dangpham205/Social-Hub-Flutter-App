import 'package:endterm/widgets/tik_tok_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../theme/colors.dart';
import 'column_social_icon.dart';
import 'like_animation.dart';

class RightPanel extends StatefulWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;

  const RightPanel({
    Key? key,
    required this.size,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.profileImg,
    required this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: widget.size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: widget.size.height * 0.3,
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: [
                        LikeAnimation(
                          isDisplaying: isLikeAnimating,
                          smallLike: true,
                          child: IconButton(
                            iconSize: 45,
                            icon: isLikeAnimating
                                ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                                : const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              isLikeAnimating = !isLikeAnimating;
                              setState(() {

                              });
                            },
                            // onPressed: () => FireStoreMethods().likePost(
                            //   widget.snap['postId'].toString(),
                            //   user.uid,
                            //   widget.snap['likes'],
                            // ),
                          ),
                        ),
                        Text(
                          widget.likes,
                          style: TextStyle(
                              color: white, fontSize: 12, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    getIcons(TikTokIcons.chat_bubble, widget.comments, 35.0),
                    getIcons(TikTokIcons.reply, widget.shares, 25.0),
                    getAlbum(widget.albumImg)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
