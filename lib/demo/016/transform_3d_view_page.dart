import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/demo/012/bubbles_animation_login_page.dart';

/// 3D变换效果
class Transform3DViewPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double _rotateX = 0.0;
    double _rotateY = 0.0;

    return StatefulBuilder(builder: (context, state) {
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
              state(() {
                _rotateX += details.delta.dy * .01;
                _rotateY += details.delta.dx * -.01;
              });
            },
            onDoubleTap: () {
              state(() {
                _rotateX = 0.0;
                _rotateY = 0.0;
              });
            },
          ),
        ),
      );
    });
  }
}
