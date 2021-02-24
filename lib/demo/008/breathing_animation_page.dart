import 'package:flutter/material.dart';

/// 478呼吸法动画 ， 使用单个控制器
/// 另外要实现此效果，也可以使用双控制器， async await 方式,
/// 不断改为控制器的 duration 来达到同样的效果
class BreathingAnimationPage extends StatefulWidget {
  @override
  _BreathingAnimationPageState createState() => _BreathingAnimationPageState();
}

class _BreathingAnimationPageState extends State<BreathingAnimationPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
      duration: Duration(seconds: 20)
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 4 秒吸气， 7 秒保持， 8 秒吐气
    /// 0.0 0.2      0.55   0.95
    /// ++++ ======= -------- =

    // 吸气 4秒，总共20秒，那就是 4 / 20 = 0.2
    final _animation1 = Tween(begin: 0.0, end: 1.0)
      .chain(CurveTween(curve: Interval(0.0, 0.2)))
      .animate(_controller);

    // 憋气 7 秒
    final _animation2 = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Interval(0.22, 0.54)))
        .animate(_controller);

    // 吐气 从 11 秒开始，持续 8 秒
    final _animation3 = Tween(begin: 1.0, end: 0.0)
      .chain(CurveTween(curve: Interval(0.55, 0.95)))
      .animate(_controller);

    return Scaffold(
      appBar: AppBar(title: Text("478呼吸法动画")),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_controller.value <= 0.2
                    ? "吸气"
                    : (_controller.value <= 0.55
                    ? "憋气"
                    : "吐气"),
                    style: TextStyle(fontSize: 48)),
                SizedBox(height: 32),
                Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // 憋气时加一个颜色变化的动画
                      color: _controller.value <= 0.2 || _controller.value >= 0.55 
                        ? Colors.blue
                        : Colors.blue.withOpacity(
                          // 颜色淡入淡出4次，所以时间分成4段
                          _animation2.value <= 0.25 ||
                          (_animation2.value > 0.5 && _animation2.value <= 0.75) ||
                          _animation2.value >= 1.0
                              ? 1.0 - (_animation2.value * 4.0 % 1.0) * 0.75
                              : 0.25 + (_animation2.value * 4.0 % 1.0) * 0.75
                      ),
                      gradient: RadialGradient(
                          colors: [Colors.blue[600], Colors.blue[100]],
                          // 使用环形渐变的stops实现呼吸效果
                          stops: _controller.value <= 0.2  // 0.2即前部分的4秒吸气过程
                              ? [_animation1.value, _animation1.value + 0.1]
                              : [_animation3.value, _animation3.value + 0.1]
                      )
                  ),
                ),
                SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () => _controller.repeat(),
      ),
    );
  }
}
