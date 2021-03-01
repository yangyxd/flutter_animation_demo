import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_demo/demo/012/bubbles_animation_login_page.dart';

/// 淡入渐变裁剪滚动区域效果
class ClipScrollViewPage extends StatefulWidget {
  @override
  _ClipScrollViewPageState createState() => _ClipScrollViewPageState();
}

class _ClipScrollViewPageState extends State<ClipScrollViewPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Widget> msgList;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
        duration: Duration(seconds: 6))
      ..repeat(reverse: true);
    msgList = List<Widget>.generate(30, (index) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 12, 0),
            child: Icon(Icons.tag_faces, color: Colors.yellow, size: 16),
          ),
          Expanded(child: Text(_messages[Random().nextInt(_messages.length)],
            style: TextStyle(
                color: Colors.black87,
                fontSize: 13.0,
                height: 2.0
            ),
            textAlign: TextAlign.left,
          ))
        ],
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 背景渐变效果
          buildBackgroundWidget(),
          // 气泡动画背景
          BobbleAnimationWidget(delay: 200),
          // 标题栏
          AppBar(elevation: 0.0, backgroundColor: Colors.transparent),
          // 滚动文字区域
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: _screen.size.width * 0.65,
              height: (_screen.size.height - _screen.padding.vertical) * 0.5,
              margin: EdgeInsets.only(left: 24, bottom: 24),
              child: ShaderMask(
                child: SingleChildScrollView(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: msgList,
                  ),
                ),
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xbf000000), Color(0xff000000)],
                    stops: [0.0, 0.2, 1.0],
                    tileMode: TileMode.repeated,
                  ).createShader(bounds);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  final _messages = <String>[
    "上一期我们做了点基本的控制台效果，这一期，我们继续做一些简单的动画，让页面酷炫起来。",
    "你好吗？",
    "声音真好听",
    "有两下子啊，咋不整个扣扣群？",
    "好久没看了 没时间 先投币[吃瓜]",
    "中国代表当面警告英国德国：你们制造罪恶够多了，该反省的是你们"
  ];

  AnimatedBuilder buildBackgroundWidget() {
    return AnimatedBuilder(animation: _controller, builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorTween(begin: Colors.orange, end: Colors.blue).evaluate(_controller),
                  ColorTween(begin: Colors.black, end: Colors.red).evaluate(_controller),
                  ColorTween(begin: Colors.cyan, end: Colors.yellow).evaluate(_controller)
                ],
                stops: [
                  Tween(begin: 0.15, end: 0.65).animate(_controller).value,
                  Tween(begin: 1.5, end: 0.85).animate(_controller).value,
                  Tween(begin: 0.5, end: 1.2).animate(_controller).value,
                ]
              )
            ),
          );
        });
  }
}
