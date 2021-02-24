import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/utils.dart';

/// 补间动画
class TweenBuilderAnimationPage extends StatefulWidget {
  @override
  _TweenBuilderAnimationPageState createState() => _TweenBuilderAnimationPageState();
}

class _TweenBuilderAnimationPageState extends State<TweenBuilderAnimationPage> {
  bool _scaleAni = true;
  bool _rotateAni = false;
  bool _curve = false;

  @override
  Widget build(BuildContext context) {
    final _tweenEnd = 0.1 + Utils.random(25).toDouble() / 10.0;
    print(_tweenEnd);

    return Scaffold(
      appBar: AppBar(
        title: Text("补间动画示例"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ListTile(title: Text("缩放动画"), leading: Checkbox(value: _scaleAni), onTap: () {
                setState(() => _scaleAni = !_scaleAni);
              }),
              ListTile(title: Text("旋转动画"), leading: Checkbox(value: _rotateAni), onTap: () {
                setState(() => _rotateAni = !_rotateAni);
              }),
              ListTile(title: Text("启用 Curve"), leading: Checkbox(value: _curve), onTap: () {
                setState(() => _curve = !_curve);
              }),
              Text("点击动画区域试试 ^_^", style: TextStyle(color: Colors.orange)),
              Expanded(child: buildDemoWidget(_tweenEnd))
            ],
          ),
        ],
      ),
    );
  }

  Center buildDemoWidget(double _tweenEnd) {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.5, end: _tweenEnd),
        curve: _curve ? Curves.elasticOut : Curves.linear,
        duration: Duration(seconds: 1),
        builder: (context, value, child) {
          // 添加缩放动画
          if (_scaleAni) {
            child = Transform.scale(
              scale: value,
              child: child,
            );
          }
          // 添加旋转动画
          if (_rotateAni) {
            child = Transform.rotate(
              // 转一圈是 6.28， 半圈是 3.14
              angle: value * pi * 2,
              child: child,
            );
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 300,
              height: 300,
              color: Colors.blueGrey,
              alignment: Alignment.center,
              child: child,
            ),
            onTap: () {
              // 点击刷新会随机生成一个缩放值
              setState(() {});
            },
          );
        },
        child: Text("你好", style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
