import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/model/dao.dart';

/// 不同控件切换过渡动画
class WidgetSwitchAnimationPage extends StatefulWidget {
  @override
  _WidgetSwitchAnimationPageState createState() => _WidgetSwitchAnimationPageState();
}

class _WidgetSwitchAnimationPageState extends State<WidgetSwitchAnimationPage> {
  Widget _child;
  int flag = 0;
  bool _scaleContainer = true;
  bool _slideTransition = false;
  bool _scaleTransition = false;

  /// 动画区域背景色
  final _colors = <Color>[Colors.green, Colors.blue, Colors.white, Colors.red];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("小部件切换过渡动画")),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Center(
            child: AnimatedContainer(
              width: _scaleContainer ? 250 + flag * 20.0 : 260,
              height: _scaleContainer ? 300 - flag * 10.0 : 260,
              duration: Duration(milliseconds: 1000),
              color: _colors[flag],
              child: AnimatedSwitcher(
                transitionBuilder: (child, animation) {
                  if (_slideTransition)
                    child = SlideTransition(
                      position: Tween(begin: Offset(-0.1, 0.0), end: Offset(0.1, 0.0)).animate(animation),
                      child: child,
                    );
                  if (_scaleTransition)
                    child = ScaleTransition(scale: animation, child: child);
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                duration: Duration(milliseconds: 1200),
                child: _child ?? _buildImage(),
              ),
            ),
          )),
          ListTile(title: Text("ScaleContainer"), leading: Checkbox(value: _scaleContainer), onTap: () {
            setState(() {
              _scaleContainer = !_scaleContainer;
            });
          }),
          ListTile(title: Text("SlideTransition"), leading: Checkbox(value: _slideTransition), onTap: () {
            setState(() {
              _slideTransition = !_slideTransition;
            });
          }),
          ListTile(title: Text("ScaleTransition"), leading: Checkbox(value: _scaleTransition), onTap: () {
            setState(() {
              _scaleTransition = !_scaleTransition;
            });
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: (){
          flag++;
          if (flag > 3) flag = 0;
          setState(() {
            switch (flag) {
              case 0: _child = null; break;
              case 1: _child = Center(key: ValueKey("Hello"),
                  child: Text("Hello", style: TextStyle(fontSize: 100))); break;
              case 2: _child = Center(key: ValueKey("你好"),
                  child: Text("你好", style: TextStyle(fontSize: 100, color: Colors.red))); break;
              case 3: _child = Center(child: SizedBox(width: 120, height: 120,
                  child: CircularProgressIndicator())); break;
            }
          });
        },
      ),
    );
  }

  Widget _buildImage() =>
      CachedNetworkImage(imageUrl: Dao.images[Random().nextInt(Dao.images.length - 1)]);
}
