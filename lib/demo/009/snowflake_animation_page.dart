import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/utils.dart';

/// 下雪动画
class SnowflakeAnimationPage extends StatefulWidget {
  @override
  _SnowflakeAnimationPageState createState() => _SnowflakeAnimationPageState();
}

class _SnowflakeAnimationPageState extends State<SnowflakeAnimationPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  /// 100 个雪花
  List<Snowflake> _snowflakes;

  /// 记录下屏幕的宽高, 变化时重新初始化
  Size _size;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: AnimatedBuilder(animation: _controller, builder: (context, child) {

              final __size = MediaQuery.of(context).size;
              if (__size.width != _size?.width) {
                print("size changed.");
                _size = Size(__size.width, __size.height);
                SizeUtils.updateMediaData();
                initSnowflake();
              } else {
                if (__size.height != _size?.height) {
                  _size = Size(__size.width, __size.height);
                  SizeUtils.updateMediaData();
                }
                _snowflakes.forEach((e) => e.fall());
              }

              return Container(
                child: CustomPaint(
                  painter: MyPainter(_snowflakes),
                ),
              );
            }),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.white54, Colors.white],
                stops: [0.0, 0.7, 0.95]
              )
            ),
          ),
          AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  /// 初始化雪花
  initSnowflake() {
    final _count = max((SizeUtils.screenWidthDp / 500 * 100).toInt(), 100);
    _snowflakes = List<Snowflake>.generate(_count, (index) => Snowflake());
    print("Snowflake count: $_count");
  }
}

class MyPainter extends CustomPainter {
  List<Snowflake> snowflakes;
  MyPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    // print(size);
    final _paint = Paint()..color = Colors.white;
    final _blackPaint = Paint()..color = Colors.black45;

    canvas.drawCircle(size.center(Offset(0, size.height * 0.5 - 180)), 60, _paint);
    canvas.drawOval(Rect.fromCenter(
        center: size.center(Offset(0, size.height * 0.5 - 50)),
        width: 200, height: 250), _paint);

    final _eyeOffsetY = size.height * 0.5 - 190;
    canvas.drawCircle(size.center(Offset(-12, _eyeOffsetY)), 2, _blackPaint);
    canvas.drawCircle(size.center(Offset(12, _eyeOffsetY)), 2, _blackPaint);

    snowflakes.forEach((e) {
      canvas.drawCircle(Offset(e.x, e.y), e.radius, _paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Snowflake {
  double x = Random().nextDouble() * SizeUtils.screenWidthDp;
  double y = Random().nextDouble() * SizeUtils.screenHeightDp;
  double radius = Random().nextDouble() * 3 + 1.5;
  double velocity = Random().nextDouble() * 4 + 1;

  fall () {
    y += velocity;
    if (y > SizeUtils.screenHeightDp + 50) {
      y = 0;
      x = Random().nextDouble() * SizeUtils.screenWidthDp;
      radius = Random().nextDouble() * 3 + 1.5;
      velocity = Random().nextDouble() * 4 + 1;
    }
  }
}