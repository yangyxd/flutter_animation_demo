import 'package:flutter/material.dart';

class CounterAnimationPage extends StatefulWidget {
  @override
  _CounterAnimationPageState createState() => _CounterAnimationPageState();
}

class _CounterAnimationPageState extends State<CounterAnimationPage> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    final _txtStyle = TextStyle(fontSize: 50, color: Colors.white);
    final _duration = Duration(milliseconds: 200);

    return Scaffold(
      appBar: AppBar(title: Text("翻滚数字")),
      body: Center(
        child: Container(
          width: 300,
          height: 60,
          color: Colors.redAccent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              AnimationCounter(
                duration: _duration,
                value: value ~/ 100,
                textStyle: _txtStyle,
              ),
              AnimationCounter(
                duration: _duration,
                value: value ~/ 10 % 10,
                textStyle: _txtStyle,
              ),
              AnimationCounter(
                duration: _duration,
                value: value % 10,
                textStyle: _txtStyle,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {
            setState(() {
              value = value + 1;
            });
          }, tooltip: "+1"),
          SizedBox(height: 8),
          FloatingActionButton(child: Icon(Icons.arrow_drop_down), onPressed: () {
            setState(() {
              value = value - 1;
            });
          }, tooltip: "-1",)
        ],
      ),
    );
  }
}


class AnimationCounter extends StatelessWidget {
  final TextStyle textStyle;
  final int value;
  final Duration duration;

  const AnimationCounter({Key key,
    @required this.value,
    @required this.duration,
    this.textStyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 计算一下文字的大小
    final painter = TextPainter(
        locale: Localizations.localeOf(context),
        textDirection: TextDirection.ltr,
        textScaleFactor: 1.2,
        maxLines: 1,
        text: TextSpan(text: "$value", style: textStyle)
    );
    painter.layout(maxWidth: double.infinity);
    return SizedBox(
      width: painter.width,
      child: TweenAnimationBuilder(
        duration: duration,
        tween: Tween(end: value.toDouble()),
        builder: (context, value, child) {
          // 得到整数部分
          final whole = value ~/ 1;
          // 得到小数部分，作为滚动进度
          final decimal = value - whole;
          return Stack(
            children: [
              Positioned(
                top: -painter.height * decimal,
                child: Opacity(
                  opacity: 1.0 - decimal,
                  child: Text("$whole", style: textStyle, maxLines: 1),
                ),
              ),
              Positioned(
                top: painter.height - painter.height * decimal,
                child: Opacity(
                  opacity: decimal,
                  child: Text("${whole + 1}", style: textStyle, maxLines: 1),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
