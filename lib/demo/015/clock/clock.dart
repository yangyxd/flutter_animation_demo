import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// 时钟
class Clock extends StatefulWidget {
  /// 钟边外圈颜色
  final Color circleColor;
  /// 阴影颜色
  final Color shadowColor;
  final double shadowBlurRadius;
  /// 时间样式
  final ClockText clockText;

  /// 表盘
  final Color faceColor;
  final Color faceShadowColor;
  final Color faceTickColor;
  final TextStyle textStyle;

  /// 是否显示刻度
  final bool showTick;
  /// 是否显示文字
  final bool showText;

  /// 刻度 padding
  final EdgeInsetsGeometry paddingTick;
  final double faceAspectRatio;

  /// 指针
  final Color handHoursColor, handMinuteColor, handSecondsColor;
  final double handCenterSize;
  final EdgeInsetsGeometry paddingHand;

  /// 更新间隔
  final Duration updateDuration;

  const Clock({
    Key key,
    this.circleColor,
    this.shadowColor,
    this.shadowBlurRadius = 0.0,
    this.clockText = ClockText.roman,
    this.faceColor,
    this.faceShadowColor,
    this.faceTickColor,
    this.faceAspectRatio = 0.75,
    this.textStyle,
    this.showTick = true,
    this.showText = true,
    this.paddingTick,
    this.handHoursColor,
    this.handMinuteColor,
    this.handSecondsColor,
    this.handCenterSize = 6.0,
    this.paddingHand,
    this.updateDuration = const Duration(seconds: 1)
  }) : super(key: key);

  @override
  _ClockState createState() => _ClockState();

  static DateTime getSystemTime() => DateTime.now();
}

class _ClockState extends State<Clock> {
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(widget.updateDuration, (t) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datetime = Clock.getSystemTime();
    return AspectRatio(aspectRatio: 1.0, child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(offset: Offset(0.0, 5.0),
              blurRadius: widget.shadowBlurRadius,
              color: widget.shadowColor ?? Theme.of(context).primaryColor.withOpacity(0.15)),
          BoxShadow(offset: Offset(0.0, 5.0),
              blurRadius: 12.0,
              spreadRadius: -8,
              color: widget.circleColor ?? Colors.white),
        ]
      ),
      child: Stack(
        children: [
          // 背景
          ClockFace(
            clockText: widget.clockText,
            faceAspectRatio: widget.faceAspectRatio,
            faceColor: widget.faceColor ?? Theme.of(context).primaryColor.withOpacity(0.75),
            faceShadowColor: widget.faceShadowColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          // 表盘
          Container(
            padding: widget.paddingTick ?? const EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity,
            child: widget.showText == false && widget.showTick == false
                ? null
                : RepaintBoundary(
              child: CustomPaint(
                painter: ClockDialPainter(
                  datetime: datetime,
                  clockText: widget.clockText,
                  textStyle: widget.textStyle ?? TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 15.0,
                  ),
                  tickColor: widget.faceTickColor,
                  showText: widget.showText ?? false,
                  showTick: widget.showTick ?? true,
                ),
              ),
            )
          ),
          // 时钟
          AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: widget.paddingHand ?? const EdgeInsets.all(20.0),
                  child: CustomPaint(painter: HourHandPainter(
                    datetime: datetime,
                    hoursColor: widget.handHoursColor ?? Theme.of(context).primaryColorDark,
                    minuteColor: widget.handMinuteColor,
                    secondsColor: widget.handSecondsColor ?? widget.faceColor,
                    centerSize: widget.handCenterSize,
                  ))
              )
          ),
        ],
      ),
    ));
  }
}

enum ClockText{
  /// 古罗马样式
  roman,
  /// 数字样式
  arabic
}

class ClockFace extends StatelessWidget{

  final ClockText clockText;
  final Color faceColor;
  final Color faceShadowColor;
  final double faceAspectRatio;
  ClockFace({this.clockText = ClockText.arabic,
    this.faceAspectRatio,
    this.faceColor,
    this.faceShadowColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: faceAspectRatio ?? 0.75,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: faceColor,
              boxShadow: [
                BoxShadow(
                    offset: Offset(8.0, 0),
                    blurRadius: 13,
                    spreadRadius: 1,
                    color: faceShadowColor
                )
              ]
          ),
        ),
      ),
    );
  }
}

class ClockDialPainter extends CustomPainter{

  static const romanNumeralList = <String>[
    'XII',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI',
  ];

  static const numList = <int>[12,1,2,3,4,5,6,7,8,9,10,11];

  final ClockText clockText;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final double tickLength = 6.0;
  final double tickWidth = 4.0;

  final bool showTick;
  final bool showText;

  final DateTime datetime;

  ClockDialPainter({
    this.datetime,
    this.clockText,
    this.textStyle,
    this.showText = true,
    this.showTick = true,
    Color tickColor,
  }) : tickPaint = Paint(),
    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    ) {
    tickPaint.color = tickColor ?? Colors.black12;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final w = min(size.width, size.height);
    final angle = 2 * pi / 60;
    final radius = w / 2;

    // 绘制刻度
    if (showTick == true) {
      canvas.save();
      canvas.translate(size.width * 0.5, size.height * 0.5);
      for (var i = 0; i < 60; i++) {
        tickMarkLength = tickLength;
        tickPaint.strokeWidth = i % 5 == 0 ? tickWidth : 2;
        canvas.drawLine(Offset(0.0, -radius),
            Offset(0.0, -radius + tickMarkLength +
                (i % 5 == 0 ? tickMarkLength * 0.55 : 0)), tickPaint);
        canvas.rotate(angle);
      }
      canvas.restore();
    }

    // 绘制文字
    if (showText == true) {
      for (var i = 0; i < 12; i++) {
        canvas.save(); //与restore配合使用保存当前画布
        canvas.translate(
            0.0, -radius + w * 0.87); //平移画布画点于时钟的12点位置，+30为了调整数字与刻度的间隔
        final text = (clockText == ClockText.roman
            ? romanNumeralList[(i + 6) % 12]
            : numList[(i + 6) % 12].toString());
        textPainter.text = TextSpan(text: text, style: textStyle);
        textPainter.layout();
        canvas.rotate(-deg2Rad(30) * i); //保持画数字的时候竖直显示
        textPainter.paint(canvas, Offset(
            (size.width - textPainter.width) * 0.5,
            (size.height - textPainter.height) * 0.5
        ));
        canvas.restore();
        canvas.rotate(deg2Rad(30)); //画布旋转一个小时的刻度，把数字和刻度对应起来
      }
    }
  }

  //角度转弧度
  num deg2Rad(num deg) => deg * (pi / 180.0);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HourHandPainter extends CustomPainter {
  final Paint tickPaint;
  final Color secondsColor;
  final Color minuteColor;
  final Color hoursColor;
  final double centerSize;
  DateTime datetime;

  HourHandPainter({
    this.datetime,
    this.secondsColor,
    this.minuteColor,
    this.hoursColor,
    this.centerSize,
  }) : tickPaint = Paint() {
    tickPaint.strokeCap = StrokeCap.round;
    tickPaint.style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;

    int hours = datetime.hour;
    int minutes = datetime.minute;
    int seconds = datetime.second;
    //时针角度//以下都是以12点为0°参照
    //12小时转360°所以一小时30°
    final hoursAngle = (minutes / 60 + hours - 12) * pi / 6;//把分钟转小时之后*（2*pi/360*30）
    //分针走过的角度,同理,一分钟6°
    final minutesAngle = (minutes + seconds / 60) * pi / 30;//(2*pi/360*6)
    //秒针走过的角度,同理,一秒钟6°
    final secondsAngle = seconds * pi / 30;


    canvas.translate(size.width * 0.5, size.height * 0.5);

    //画时针
    tickPaint.color = hoursColor ?? Colors.black87;
    tickPaint.strokeWidth = 5;
    canvas.rotate(hoursAngle);
    canvas.drawLine(Offset.zero, Offset(0, -radius + 80), tickPaint);
    //画分针
    tickPaint.color = minuteColor ?? Colors.black54;
    tickPaint.strokeWidth = 3;
    canvas.rotate(-hoursAngle);//先把之前画时针的角度还原。
    canvas.rotate(minutesAngle);
    canvas.drawLine(Offset.zero, Offset(0, -radius + 60), tickPaint);
    //画秒针
    tickPaint.color = secondsColor ?? Colors.redAccent;
    tickPaint.strokeWidth = 1;
    canvas.rotate(-minutesAngle);//同理
    canvas.rotate(secondsAngle);
    canvas.drawLine(Offset.zero, Offset(0, -radius + 30), tickPaint);

    //画中心圆盖
    if (centerSize > 0.1) {
      tickPaint.color = tickPaint.color.withOpacity(1.0);
      tickPaint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, centerSize, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}