import 'dart:math';

import 'package:flutter/material.dart';

/// 波浪效果登录页
/// 参考： https://www.cnblogs.com/yangyxd/p/14428913.html
class WaterWaveLoginAnimationPage extends StatefulWidget {
  @override
  _WaterWaveLoginAnimationPageState createState() =>
      _WaterWaveLoginAnimationPageState();
}

class _WaterWaveLoginAnimationPageState
    extends State<WaterWaveLoginAnimationPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
      value: 0.0,
      upperBound: 1,
      lowerBound: -1,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    final _height = max(_media.padding.top + _media.size.height * 0.45, 120.0);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildHeaderWidget(height: _height + 24, child: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Text("欢迎登录",
                style: TextStyle(fontSize: 48, color: Colors.white)),
          )),
          AppBar(elevation: 0.0, backgroundColor: Colors.transparent),
          _buildBottomEditAndButton(_height - 35),
        ],
      ),
    );
  }

  Widget _buildHeaderWidget({Widget child, double height}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipPath(
          clipper: HeaderClipper(_controller.value),
          child: child,
        );
      },
      child: Material(
        elevation: 10,
        child: Container(
          width: double.infinity,
          height: height,
          alignment: Alignment.center,
          child: child,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xffe0647b), Color(0xfffcdd89)])),
        ),
      ),
    );
  }

  Widget _buildBottomEditAndButton(double height) {
    return Positioned(
        top: height,
        bottom: 0,
        left: 0,
        right: 0,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 55, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildInputWidget('请输入账号'),
              SizedBox(height: 16),
              buildInputWidget('请输入密码', isPass: true),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50.0)),
                  ),
                  child: Text('登录',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildInputWidget(String hint, {bool isPass = false}) {
    return TextField(
      //是否隐藏文本
      obscureText: isPass,
      //文本的边框装饰
      decoration: InputDecoration(
        //提示文本
        hintText: hint,
        //提示文本的样式
        hintStyle: TextStyle(color: Color(0xFFACACAC), fontSize: 14),
        //输入内容的内边距
        contentPadding: EdgeInsets.only(top: 20, bottom: 20, left: 38),
        //输入框可用时的边框样式
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        //输入框获取输入焦点时的边框样式
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  ///取值为 -1 ~ 1.0
  final double moveFlag;

  HeaderClipper(this.moveFlag);

  @override
  Path getClip(Size size) {
    final path = Path();
    // 移动到点 P0 点
    path.lineTo(0, size.height * 0.8);
    // 计算控制点 P1 的坐标
    final xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * sin(moveFlag * pi);
    final yCenter = size.height * 0.8 + 69 * cos(moveFlag * pi);

    // 构建 二阶贝塞尔曲线
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => true;
}
