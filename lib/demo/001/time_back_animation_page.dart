
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/utils.dart';

/// 倒计时动画效果
class TimeBackAnimationPage extends StatefulWidget {
  final double totalTime;

  const TimeBackAnimationPage({Key key, this.totalTime = 100000}): super(key: key);

  @override
  _TimeBackAnimationPageState createState() => _TimeBackAnimationPageState();
}

class _TimeBackAnimationPageState extends State<TimeBackAnimationPage> with SingleTickerProviderStateMixin {
  Timer _timer;
  final _streamController = StreamController<double>();

  double _process = 1000;
  double _borderWidth = 2.0;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  initTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _process += 100;

      if (_process % 2000 == 0) {
        if (_borderWidth == 2.0)
          _borderWidth = 30.0;
        else
          _borderWidth = 2.0;
      }

      if (_process > widget.totalTime) {
        _timer.cancel();
      }

      _streamController.add(_process);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildBackImage(),
            _buildBlurLayer(),
            _buildAppBar(),
            GestureDetector(
              child: _buildTimeView(),
              onTap: () {
                _process = 0.0;
                initTimer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() => AppBar(title: Text("倒计时效果测试"),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent);

  Widget _buildBackImage() => Positioned.fill(
      child: Image.asset("assets/images/001.jpg",
          fit: BoxFit.fill));

  Widget _buildBlurLayer() {
    return BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
          color: Colors.black.withOpacity(0.02)
      ),
    );
  }

  Widget _buildTimeView() {
    return StreamBuilder<double>(
        initialData: 0.0,
        stream: _streamController.stream,
        builder: (context, snapshot) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200], width: 5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.white, blurRadius: _borderWidth)
                ]
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: 200, height: 200, child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[100],
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  value: snapshot.data / widget.totalTime,
                )),
                Text("${(widget.totalTime - snapshot.data) ~/ 1000}",
                  style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      fontFamily: Utils.fontFamily,
                      color: Colors.blue
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        }
    );
  }
}
