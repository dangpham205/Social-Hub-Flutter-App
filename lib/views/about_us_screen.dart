import 'package:endterm/constants/colors.dart';
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
        title: const Text('Our team: ', style: TextStyle(color: cblack),),
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
                userCol('https://preview.redd.it/d3n9acugx3g41.jpg?auto=webp&s=f41237f465caf15dc38349b8a4e691a584632f0b', 'Dương Chí Kiện', ' 519H0077'),
                const SizedBox(width: 60,),
                userCol('https://preview.redd.it/d3n9acugx3g41.jpg?auto=webp&s=f41237f465caf15dc38349b8a4e691a584632f0b', 'Phạm Hải Đăng', ' 519H0277'),
              ],
            ),
            const SizedBox(height: 80,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userCol('https://preview.redd.it/d3n9acugx3g41.jpg?auto=webp&s=f41237f465caf15dc38349b8a4e691a584632f0b', 'Võ Nguyễn Duy Anh', ' 519Hxxxx'),
                const SizedBox(width: 60,),
                userCol('https://preview.redd.it/d3n9acugx3g41.jpg?auto=webp&s=f41237f465caf15dc38349b8a4e691a584632f0b', 'Nguyễn Chí Nhân', ' 519Hxxxx'),
              ],
            ),
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
                width: 115,
                height: 115,
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
                width: 100,
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