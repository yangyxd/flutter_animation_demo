import 'package:flutter/material.dart';

/// 路径绘制动画
class PathPainterAnimationPage extends StatefulWidget {
  @override
  _PathPainterAnimationPageState createState() => _PathPainterAnimationPageState();
}

class _PathPainterAnimationPageState extends State<PathPainterAnimationPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(
      milliseconds: 1500,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("路径绘制动画"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {
                  if (_controller.value == 1.0)
                    _controller.reset();
                  _controller.forward();
                }, child: Text("开始")),
                ElevatedButton(onPressed: () => _controller.stop(), child: Text("停止")),
              ],
            )
          ),
          Expanded(child: Container(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CustomPainter(200, Colors.deepOrange, _controller.value),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}

class _CustomPainter extends CustomPainter {
  final double size;
  final Color color;
  final double progress;

  final _paint = Paint()
    ..strokeWidth = 6
    ..style = PaintingStyle.stroke;

  _CustomPainter(this.size, this.color, this.progress);

  @override
  void paint(Canvas canvas, Size _size) {
    final path = Path()
      ..addRect(Rect.fromCenter(center: _size.center(Offset.zero),
        width: size, height: size));

    _paint.color = color;
    
    // 测量path
    final pathMetrics = path.computeMetrics();
    // 获取第一小节的信息
    final pathMetric = pathMetrics.first;
    // 测量并截剪Path
    final extPath = pathMetric.extractPath(0.0, pathMetric.length * progress,
        startWithMoveTo: true);
    
    canvas.drawPath(extPath, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}