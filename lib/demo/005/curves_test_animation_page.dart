import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/utils.dart';
import 'package:flutter_animation_demo/widgets/icon_button_ex.dart';

/// 动画控件及曲线 (Curves）
class CurvesTestAnimationPage extends StatefulWidget {
  @override
  _CurvesTestAnimationPageState createState() => _CurvesTestAnimationPageState();
}

class _CurvesTestAnimationPageState extends State<CurvesTestAnimationPage> {
  Timer _timer;

  int flag = 0;
  double left = 50;
  double top = 50;

  int curve = 0;

  /// 动画区域背景色
  final _colors = <Color>[Colors.green, Colors.blue, Colors.amber, Colors.red];

  /// Curves 选项
  final _menus = <Map<String, dynamic>>[
    {'title': 'linear', 'type': Curves.linear},

    {'title': 'easeInBack', 'type': Curves.easeInBack},
    {'title': 'ease', 'type': Curves.ease},
    {'title': 'easeIn', 'type': Curves.easeIn},
    {'title': 'easeOut', 'type': Curves.easeOut},
    {'title': 'easeInCirc', 'type': Curves.easeInCirc},
    {'title': 'easeInCubic', 'type': Curves.easeInCubic},
    {'title': 'easeInExpo', 'type': Curves.easeInExpo},
    {'title': 'easeInOutExpo', 'type': Curves.easeInOutExpo},
    {'title': 'easeInOutQuad', 'type': Curves.easeInOutQuad},
    {'title': 'easeInOutQuart', 'type': Curves.easeInOutQuart},
    {'title': 'easeInOutSine', 'type': Curves.easeInOutSine},
    {'title': 'easeInQuad', 'type': Curves.easeInQuad},
    {'title': 'easeInQuart', 'type': Curves.easeInQuart},
    {'title': 'easeInSine', 'type': Curves.easeInSine},
    {'title': 'easeInToLinear', 'type': Curves.easeInToLinear},

    {'title': 'bounceInOut', 'type': Curves.bounceInOut},
    {'title': 'bounceIn', 'type': Curves.bounceIn},
    {'title': 'bounceOut', 'type': Curves.bounceOut},

    {'title': 'decelerate', 'type': Curves.decelerate},

    {'title': 'elasticIn', 'type': Curves.elasticIn},
    {'title': 'elasticOut', 'type': Curves.elasticOut},
    {'title': 'elasticInOut', 'type': Curves.elasticInOut},

    {'title': 'fastLinearToSlowEaseIn', 'type': Curves.fastLinearToSlowEaseIn},
    {'title': 'fastOutSlowIn', 'type': Curves.fastOutSlowIn},

    {'title': 'slowMiddle', 'type': Curves.slowMiddle},
  ];

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 1600), (timer) {
      final _screen = MediaQuery.of(context);
      final _size = _screen.size;
      setState(() {
        flag = flag >= 3 ? 0 : flag + 1;
        top = Utils.random((_size.height - _screen.viewPadding.vertical - 80 - 220).toInt()).toDouble();
        left = Utils.random((_size.width - _screen.viewPadding.horizontal - 210).toInt()).toDouble();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("动画控件及曲线")),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container()),
              Divider(height: 0.35, indent: 16),
              ListTile(
                title: Text("Curve 曲线动画"),
                subtitle: Text(_menus[curve]["title"]),
                trailing: IconButtonEx<Curve>(
                  icon: Icon(Icons.arrow_drop_down),
                  menus: _menus,
                  menuInitialValue: _menus[curve]["type"] as Curve,
                  onSelected: (value) {
                    setState(() {
                      curve = _menus.indexWhere((e) => e["type"] == value);
                    });
                  },
                ),
              )
            ],
          ),
          AnimatedPadding(
            padding: EdgeInsets.only(left: left, top: top),
            duration: Duration(milliseconds: 1500),
            curve: _menus[curve]["type"] as Curve,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              width: 200,
              height: 200,
              color: _colors[flag],
            ),
          ),
        ],
      ),
    );
  }
}
