
import 'package:flutter/material.dart';

/// 交错动画！管理区间和曲线
class SlidingBoxAnimationPage extends StatefulWidget {
  @override
  _SlidingBoxAnimationPageState createState() => _SlidingBoxAnimationPageState();
}

class _SlidingBoxAnimationPageState extends State<SlidingBoxAnimationPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool effect = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
        duration: Duration(milliseconds: 4000));
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
      appBar: AppBar(title: Text("交错动画"), actions: [
         TextButton.icon(
           icon: Checkbox(value: effect, onChanged: (v) => setState(() => effect = v)),
           label: Text("弹跳效果", style: TextStyle(color: Colors.white)),
           style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.only(right: 16))),
           onPressed: () => setState(() => effect = !effect))
      ]),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlidingBox(_controller, color: Colors.blue[100], interval: Interval(0.0, 0.2), effect: effect),
            SlidingBox(_controller, color: Colors.blue[300], interval: Interval(0.2, 0.4), effect: effect),
            SlidingBox(_controller, color: Colors.blue[500], interval: Interval(0.4, 0.6), effect: effect),
            SlidingBox(_controller, color: Colors.blue[700], interval: Interval(0.6, 0.8), effect: effect),
            SlidingBox(_controller, color: Colors.blue[900], interval: Interval(0.8, 1.0), effect: effect),
            SizedBox(height: 50)
          ],
        ),
      ),
      floatingActionButton: StatefulBuilder(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: FloatingActionButton(
              key: UniqueKey(),
              child: Icon(_controller.isAnimating
                  ? Icons.stop
                  : Icons.play_arrow),
              backgroundColor: _controller.isAnimating ? Colors.red : null,
              onPressed: () {
                if (_controller.isAnimating) {
                  _controller.reset();
                } else {
                  // reverse　结束时反转动画
                  _controller.repeat(reverse: true);
                }
                state(() => null);
              },
            ),
          );
        },
      ),
    );
  }
}

class SlidingBox extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final Interval interval;
  final bool effect;

  const SlidingBox(this.controller, {Key key, this.color, this.interval, this.effect = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _animation;
    if (effect == true) {
      _animation = Tween(begin: Offset.zero, end: Offset(0.1, 0))
          .chain(CurveTween(curve: Curves.easeInBack)) // 弹跳效果
          .chain(CurveTween(curve: interval));
    } else {
      _animation = Tween(begin: Offset.zero, end: Offset(0.1, 0))
          .chain(CurveTween(curve: interval));
    }

    return SlideTransition(
      position: _animation.animate(controller),
      child: Container(
        width: 300,
        height: 80,
        color: color,
      ),
    );
  }
}