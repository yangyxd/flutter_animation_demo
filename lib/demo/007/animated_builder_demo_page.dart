import 'package:flutter/material.dart';

/// 自定义动画
class AnimatedBuilderDemoPage extends StatefulWidget {
  @override
  _AnimatedBuilderDemoPageState createState() => _AnimatedBuilderDemoPageState();
}

class _AnimatedBuilderDemoPageState extends State<AnimatedBuilderDemoPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))
      ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final _heightAnimation = Tween(begin: 100.0, end: 300.0)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(_controller);
    final _opacityAnimation = Tween(begin: 0.3, end: 1.0)
        .animate(_controller);

    return Scaffold(
      appBar: AppBar(
        title: Text("自定义动画"),
        actions: [
          IconButton(icon: Icon(Icons.stop), tooltip: "停止动画",
              onPressed: () => _controller.stop()),
          IconButton(icon: Icon(Icons.play_arrow), tooltip: "开始动画",
              onPressed: () => _controller.repeat(reverse: true)),
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 300,
              height: _heightAnimation.value,
              color: Colors.deepOrange,
              alignment: Alignment.center,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: child,
              ),
            );
          },
          child: Text("你好", style: TextStyle(
            fontSize: 72
          )),
        ),
      ),
    );
  }
}
