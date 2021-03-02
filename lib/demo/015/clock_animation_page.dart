import 'package:flutter/material.dart';

import 'clock/clock.dart';

/// 钟表效果
class ClockAnimationPage extends StatefulWidget {
  @override
  _ClockAnimationPageState createState() => _ClockAnimationPageState();
}

class _ClockAnimationPageState extends State<ClockAnimationPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.green
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("时钟")),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(50),
            child: Clock(
              clockText: ClockText.arabic,
              faceTickColor: Colors.orange,
              faceColor: Colors.white,
              handSecondsColor: Colors.orange,
              paddingTick: EdgeInsets.all(8),
              faceAspectRatio: 1.0,
              showText: true,
              showTick: true,
            ),
          ),
        ),
      ),
    );
  }
}
