import 'package:endterm/constants/colors.dart';
import 'package:endterm/constants/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({ Key? key }) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> with TickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var rating = true;
  var isRate = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: cblack,),
        ),
        title: const Text('Developer team: ', style: TextStyle(color: cblack),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userCol('https://i.pinimg.com/236x/62/92/bc/6292bc7fc135d814017a6cab4336c1d8.jpg', 'Dương Chí Kiện', ' 519H0077'),
                const SizedBox(width: 50,),
                userCol('https://i.pinimg.com/236x/ec/d3/2e/ecd32e08f938f6894885d2010b3de4b5.jpg', 'Phạm Hải Đăng', ' 519H0277'),
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userCol('https://i.pinimg.com/236x/0e/1c/f0/0e1cf00605082d11da6385459a3a1687.jpg', 'Võ Nguyễn Duy Anh', ' 519H0272'),
                const SizedBox(width: 50,),
                userCol('https://preview.redd.it/d3n9acugx3g41.jpg?auto=webp&s=f41237f465caf15dc38349b8a4e691a584632f0b', 'Nguyễn Chí Nhân', ' 519H0127'),
              ],
            ),
            const SizedBox(height: 50,),
            const Center(
              child: Text(
                'Please rate us: ',
                  style: TextStyle(
                    color: cblack,
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600
                  ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (isRate[0]) ? 
                IconButton(
                  onPressed: () {
                    if (rating) {
                      if (isRate[1] == true) {
                        isRate[0] = true;
                        isRate[1] = false;
                        isRate[2] = false;
                        isRate[3] = false;
                        isRate[4] = false;
                      } else {
                        isRate[0] = false;
                      }
                    }
                    setState(() {
                    });
                  },
                  icon: const Icon(
                    Icons.star,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    if (rating) {
                      isRate[0] = true;
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star_outline,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ),

                (isRate[1]) ? 
                IconButton(
                  onPressed: () {
                    if (rating) {
                      if (isRate[2] == true) {
                        isRate[0] = true;
                        isRate[1] = true;
                        isRate[2] = false;
                        isRate[3] = false;
                        isRate[4] = false;
                      } else {
                        isRate[0] = false;
                        isRate[1] = false;
                      }
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    if (rating) {
                      isRate[0] = true;
                      isRate[1] = true;
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star_outline,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ),
                (isRate[2]) ? 
                IconButton(
                  onPressed: () {
                    if (rating) {
                      if (isRate[3] == true) {
                        isRate[0] = true;
                        isRate[1] = true;
                        isRate[2] = true;
                        isRate[3] = false;
                        isRate[4] = false;
                      } else {
                        isRate[0] = false;
                        isRate[1] = false;
                        isRate[2] = false;
                      }
                    }
                    setState(() {

                    });
                  },
                  icon: const Icon(
                    Icons.star,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    if (rating) {
                      isRate[0] = true;
                      isRate[1] = true;
                      isRate[2] = true;
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star_outline,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ),
                (isRate[3]) ? 
                IconButton(
                  onPressed: () {
                    if (rating) {
                      if (isRate[4] == true) {
                        isRate[0] = true;
                        isRate[1] = true;
                        isRate[2] = true;
                        isRate[3] = true;
                        isRate[4] = false;
                      } else {
                        isRate[0] = false;
                        isRate[1] = false;
                        isRate[2] = false;
                        isRate[3] = false;
                      }
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    if (rating) {
                      isRate[0] = true;
                      isRate[1] = true;
                      isRate[2] = true;
                      isRate[3] = true;
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star_outline,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ),
                (isRate[4]) ? 
                IconButton(
                  onPressed: () {
                    if (rating) {
                      isRate[0] = false;
                      isRate[1] = false;
                      isRate[2] = false;
                      isRate[3] = false;
                      isRate[4] = false;
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    if (rating) {
                      isRate[0] = true;
                      isRate[1] = true;
                      isRate[2] = true;
                      isRate[3] = true;
                      isRate[4] = true;
                    }
                    setState(() {
                      
                    });
                  },
                  icon: const Icon(
                    Icons.star_outline,
                    size: 36,
                    color: Color(0xfffbc101),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            (rating) ? 
            GestureDetector(
              onTap: () {
                rating = false;
                showSnackBar(context, 'Thank you for your ratings!');
                setState(() {
                  
                });
              },
              child: Container(
                width: 120,
                height: 40,
                color: const Color(0xfffbc101),
                child: const Center(child: Text('Rate !', style: TextStyle(color: cblack, fontWeight: FontWeight.bold),),),
              ),
            ) : 
            const SizedBox()
          ],
        ),
      )
    );
  }

  Column userCol(String image, String name, String id) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: Container(
                width: 105,
                height: 105,
                child: const Text('a'),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xff1f005c),
                      Color(0xff5b0060),
                      Color(0xff870160),
                      Color(0xffac255e),
                      Color(0xffca485c),
                      Color(0xffe16b5c),
                      Color(0xfff39060),
                      Color(0xffffb56b),
                    ], // Gradient from https://learnui.design/tools/gradient-generator.html
                    tileMode: TileMode.mirror,
                  ),
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _controller.value * 2.0 * pi,
                  child: child,
                );
              },
            ),
            Positioned(
              child: SizedBox(
                width: 90,
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(image),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10,),
        Text(
          name,
          style: const TextStyle(
            color: cblack,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 3,),
        Text(
          id,
          style: const TextStyle(
            color: cblack,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}