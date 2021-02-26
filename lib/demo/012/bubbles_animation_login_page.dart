import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/utils.dart';

/// 气泡动画背景的登录页面
/// https://www.bilibili.com/video/BV1Nt4y1v7mc?from=search&seid=5378509521563985244
class BubblesAnimationLoginPage extends StatefulWidget {
  @override
  _BubblesAnimationLoginPageState createState() => _BubblesAnimationLoginPageState();
}

class _BubblesAnimationLoginPageState extends State<BubblesAnimationLoginPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
      duration: Duration(milliseconds: 1800),
    )..forward();
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 渐变背景
          buildBackgroundWidget(),
          // 气泡动画
          BobbleAnimationWidget(delay: 500),
          // 顶部文字
          buildHeaderWidget(),
          // 顶部导航
          AppBar(elevation: 0.0, backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.black38)),
          // 输入框和按钮
          buildBottomWidget(),
        ],
      ),
    );
  }

  Container buildBackgroundWidget() {
    return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.lightBlueAccent.withOpacity(0.3),
                Colors.lightBlue.withOpacity(0.3),
                Colors.blue.withOpacity(0.3)
              ]
            )
          ),
        );
  }

  Widget buildHeaderWidget() {
    return SafeArea(child: Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      alignment: Alignment.center,
      child: Text("Welcome login", style: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        height: 1.5,
        wordSpacing: 8.0,
        color: Colors.green
      )),
    ));
  }

  Widget buildBottomWidget() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      top: 50,
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(45, 0, 45, 16),
            child: FadeTransition(
              opacity: _controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildInputWidget("账号", icon: Icons.phone_android_outlined),
                  SizedBox(height: 14),
                  buildInputWidget("密码", icon: Icons.lock_outline, isPass: true),
                  SizedBox(height: 14),
                  SizedBox(width: double.infinity, child: Text("忘记密码",
                      textAlign: TextAlign.end, style: TextStyle(
                          fontSize: 14, color: Colors.blue
                      ))),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      child: Text("登录"),
                      style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(Colors.black12)
                      ),
                      onPressed: () => null,
                    ),
                  ),
                  SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      child: Text("注册"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.lightBlue.withOpacity(0.75)),
                          shadowColor: MaterialStateProperty.all(Colors.black12)
                      ),
                      onPressed: () => null,
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputWidget(String hint, {bool isPass = false, IconData icon}) {
    return Container(
      color: Colors.grey.withOpacity(0.15),
      child: TextField(
        //是否隐藏文本
        obscureText: isPass,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14.0,
        ),
        //文本的边框装饰
        decoration: InputDecoration(
          //提示文本
          hintText: hint,
          //输入内容的内边距
          contentPadding: EdgeInsets.only(top: 16, bottom: 16, left: 38),
          //提示文本的样式
          hintStyle: TextStyle(color: Color(0xFFACACAC), fontSize: 14),
          //输入框可用时的边框样式
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          //输入框获取输入焦点时的边框样式
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: Icon(icon, color: Colors.lightBlue, size: 16),
        ),
      ),
    );
  }

}

/// 泡泡动画小部件
class BobbleAnimationWidget extends StatefulWidget {
  /// 泡泡数量
  final int count;
  /// 动画速度
  final Duration duration;
  /// 动画开始延时
  final int delay;

  final double width;
  final double height;

  const BobbleAnimationWidget({Key key, this.count = 20,
    this.duration,
    this.delay,
    this.width = double.infinity,
    this.height = double.infinity
  }) : super(key: key);

  @override
  _BobbleAnimationWidgetState createState() => _BobbleAnimationWidgetState();
}

class _BobbleAnimationWidgetState extends State<BobbleAnimationWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Bobble> items;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
      duration: widget.duration ?? Duration(seconds: 10)
    );

    items = List<Bobble>.generate(widget.count, (index) => Bobble());

    if (widget.delay == null || widget.delay <= 0) {
      _controller.repeat();
    } else {
      Utils.sleep(widget.delay, () {
        if (this.mounted)
          _controller.repeat();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          buildBobbleWidget(context),
          // 高斯模糊层
          buildBlurBackgroundLayer()
        ],
      ),
    );
  }

  Widget buildBobbleWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: AnimatedBuilder(animation: _controller, builder: (context, _) {
        return CustomPaint(
          painter: CustomBobblePainter(items, _controller.isAnimating),
        );
      }),
    );
  }

  Widget buildBlurBackgroundLayer() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
      child: Container(
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }
}


/// 创建画布
class CustomBobblePainter extends CustomPainter{
  final List<Bobble> items;
  final bool autoPlay;
  CustomBobblePainter(this.items, this.autoPlay);

  @override
  void paint(Canvas canvas, Size size) {
    if (autoPlay != true) return;
    final paint = Paint();
    items.forEach((e) {
      e.play(size);
      paint.color = e.color;
      canvas.drawCircle(Offset(e.x, e.y), e.radius, paint);
    });
  }

  /// 是否需要刷新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Bobble {
  // 位置
  double x = -1000;
  double y = -1000;
  // 半径
  double radius = Random().nextDouble() * 100;
  // 颜色透明度
  double opacity = max(0.1, Random().nextDouble() - 0.05);
  // 运动速度
  double speed = Random().nextDouble() * 1.5 + 0.1;
  // 运动角度 2*pi = 360度
  double theta = Random().nextDouble() * (2 * pi);

  double _opacity = 0.0;

  Bobble() {
    _opacity = min(opacity, max(0.1, Random().nextDouble() - 0.05));
  }

  play(Size size) {
    // 据据点的速度和角度运动
    final _center = Offset(speed * cos(theta), speed * sin(theta));
    x = _center.dx + x;
    y = _center.dy + y;

    // 边界计算
    if ((x + radius < 0 || x - radius > size.width) && (y + radius < 0 || y - radius > size.height)) {
      radius = Random().nextDouble() * 100 + 20;
      final r2 = radius * 2;
      x = Random().nextDouble() * (size.width - r2) + radius * 0.5;
      y = Random().nextDouble() * (size.height - r2)  + radius * 0.5;
      bool isChangeOpacity = opacity <= _opacity;
      opacity = max(0.1, Random().nextDouble() - 0.05);
      if (isChangeOpacity)
        _opacity = 0.0;
    }

    // 透明度渐变出现
    if (_opacity < opacity)
      _opacity = min(opacity, _opacity + 0.015);
  }

  Color get color => Colors.white.withOpacity(_opacity);
}