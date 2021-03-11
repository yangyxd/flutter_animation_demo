import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/demo/012/bubbles_animation_login_page.dart';

/// 3D变换效果
class Transform3DViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Transform3DViewPageState();
}

class _Transform3DViewPageState extends State<Transform3DViewPage> with SingleTickerProviderStateMixin {
  double _rotateX = 0.0;
  double _rotateY = 0.0;

  double _ani2X = 0.01999;
  double _ani2Y = 0.45;
  double _x = 0.0;
  double _y = 0.0;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,
      duration: Duration(
        milliseconds: 2000
      ),
    )..addListener(() {
      setState(() {
        _rotateX = _x + _ani2X * _animation.value;
        _rotateY = _y + _ani2Y * _animation.value;
      });
    });
    _animation = Tween(begin: 0.0, end: 1.0)
      .chain(CurveTween(curve: Interval(0.0, 0.6)))
      .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // 近大远小效果
        ..rotateX(_rotateX)
        ..rotateY(_rotateY),
      alignment: Alignment.center,
      child: Scaffold(
        appBar: AppBar(
          title: Text('3D变换Demo'),
        ),
        backgroundColor: Colors.greenAccent,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              BobbleAnimationWidget(),
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Transform 3D 变换", style: TextStyle(
                        fontSize: 24
                    )),
                    SizedBox(height: 16),
                    Text("按住拖动进行3D变换\n\n双击恢复默认状态", style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepOrange
                    ), textAlign: TextAlign.center)
                  ],
                ),
              )
            ],
          ),
          onPanUpdate: (details) {
            if (_controller.isAnimating)
              _controller.stop();
            setState(() {
              _rotateX += details.delta.dy * .01;
              _rotateY += details.delta.dx * -.01;
              print("rotate X: $_rotateX, Y: $_rotateY");
            });
          },
          onDoubleTap: () {
            _x = _rotateX;
            _y = _rotateY;
            _ani2X = -_rotateX;
            _ani2Y = -_rotateY;
            _controller.forward(from: 0.0);
          },
        ),
      ),
    );
  }

}