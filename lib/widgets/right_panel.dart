import 'package:endterm/widgets/tik_tok_icons.dart';
import 'package:flutter/material.dart';


import '../theme/colors.dart';
import '../views/album_screen.dart';
import 'column_social_icon.dart';
import 'like_animation.dart';

class RightPanel extends StatefulWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  final String songName;

  const RightPanel({
    Key? key,
    required this.size,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.profileImg,
    required this.albumImg,
    required this.songName,
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
      // ignore: sized_box_for_whitespace
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
                      style: const TextStyle(
                          color: white, fontSize: 12, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                getIcons(TikTokIcons.chat_bubble, widget.comments, 35.0),
                getIcons(TikTokIcons.reply, widget.shares, 25.0),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    // shape: BoxShape.circle,
                    // color: black
                  ),
                  child: InkWell(
                    onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AlbumScreen(
                            albumName: widget.songName,
                            albumImg: widget.albumImg,
                          )))
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                        ),
                        Center(
                          child: Container(
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: NetworkImage(widget.albumImg),
                                    fit: BoxFit.cover)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
