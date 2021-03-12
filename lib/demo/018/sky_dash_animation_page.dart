import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/demo/019/plasma/plasma.dart';
import 'package:flutter_animation_demo/widgets/custom_animation.dart';
import 'package:flutter_animation_demo/widgets/timeline_tween/timeline_tween.dart';
import 'package:supercharged/supercharged.dart';

/// 天空 Sky 炫彩变幻动画
class SkyDashAnimationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SkyWidget(),
          AppBar(elevation: 0.0, backgroundColor: Colors.transparent),
        ],
      ),
    );
  }
}

// 天空效果小部件
class SkyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tween = _createTween();
    return CustomAnimation<TimelineValue<_P>>.loop(builder: (context, child, value) {
      return Stack(
        children: [
          // 背色渐变
          Positioned.fill(child: SkyGradient()),
          // 远处的云朵
          Positioned.fill(child: CloudsPlasma()),
          // 前景的云朵
          Positioned.fill(child: ForegroundCloudsPlasma()),
        ],
      );
    },
        tween: tween,
        duration: tween.duration);
  }
}

class SkyGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff214c8f),
            Color(0xff4999d9),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
    );
  }
}

class CloudsPlasma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlasmaRenderer(
      type: PlasmaType.bubbles,
      particles: 39,
      color: Color(0x44ffffff),
      blur: 0.55,
      size: 1.44,
      speed: 3.88,
      offset: 0,
      blendMode: BlendMode.srcOver,
      variation1: 0,
      variation2: 0,
      variation3: 0,
      rotation: 1.63,
    );
  }
}

class ForegroundCloudsPlasma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlasmaRenderer(
      type: PlasmaType.bubbles,
      particles: 10,
      color: Color(0x66ffffff),
      blur: 0.55,
      size: 2.44,
      speed: 3.88,
      offset: 0,
      blendMode: BlendMode.srcOver,
      variation1: 0,
      variation2: 0,
      variation3: 0,
      rotation: 1.63,
    );
  }
}

class MirrorAnimation<T> extends StatelessWidget {
  final AnimatedWidgetBuilder<T> builder;
  final Widget child;
  final Duration duration;
  final Animatable<T> tween;
  final Curve curve;
  final int fps;
  final bool developerMode;

  /// Creates a new MirrorAnimation widget.
  /// See class documentation for more information.
  MirrorAnimation({
    @required this.builder,
    @required this.tween,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.linear,
    this.child,
    this.fps,
    this.developerMode = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<T>(
      builder: builder,
      control: CustomAnimationControl.MIRROR,
      tween: tween,
      duration: duration,
      curve: curve,
      child: child,
      //fps: fps,
      //developerMode: developerMode,
    );
  }
}

const MUSIC_UNIT_MS = 6165;
enum _P { left1, top1, size1, rotate1, otherDashes }

TimelineTween<_P> _createTween() {
  var tween = TimelineTween<_P>();

  tween
      .addScene(
    begin: (0.0 * MUSIC_UNIT_MS).round().milliseconds,
    end: (0.25 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeOut,
  )
      .animate(_P.left1, tween: (1.05).tweenTo(0.2))
      .animate(_P.top1, tween: (0.6).tweenTo(0.3))
      .animate(_P.size1, tween: (0.4).tweenTo(0.3));

  tween
      .addScene(
      begin: (0.25 * MUSIC_UNIT_MS).round().milliseconds,
      end: (0.5 * MUSIC_UNIT_MS).round().milliseconds,
      curve: Curves.easeInOut)
      .animate(_P.left1, tween: (0.2).tweenTo(0.3))
      .animate(_P.top1, tween: (0.3).tweenTo(0.4))
      .animate(_P.size1, tween: (0.3).tweenTo(0.35));

  tween
      .addScene(
      begin: (0.5 * MUSIC_UNIT_MS).round().milliseconds,
      end: (0.75 * MUSIC_UNIT_MS).round().milliseconds,
      curve: Curves.easeInOut)
      .animate(_P.left1, tween: (0.3).tweenTo(0.2))
      .animate(_P.top1, tween: (0.4).tweenTo(0.3))
      .animate(_P.size1, tween: (0.35).tweenTo(0.3));

  tween
      .addScene(
    begin: (0.50 * MUSIC_UNIT_MS).round().milliseconds,
    end: (1.0 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeOut,
  )
      .animate(_P.otherDashes, tween: (0.0).tweenTo(1.0));

  var fallIntoSwarm = tween
      .addScene(
    begin: (0.75 * MUSIC_UNIT_MS).round().milliseconds,
    end: (0.83 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeOut,
  )
      .animate(_P.rotate1,
      tween: (0.1).tweenTo(0.35),
      shiftEnd: -400.milliseconds,
      curve: Curves.easeInOut)
      .animate(_P.left1, tween: (0.2).tweenTo(0.35))
      .animate(_P.top1, tween: (0.3).tweenTo(0.4))
      .animate(_P.size1, tween: (0.3).tweenTo(0.2));

  fallIntoSwarm
      .addSubsequentScene(duration: (0.17 * MUSIC_UNIT_MS).round().milliseconds)
      .animate(_P.top1, tween: (0.4).tweenTo(-0.8))
      .animate(_P.left1, tween: (0.35).tweenTo(0.25));

  tween.addScene(end: (MUSIC_UNIT_MS).milliseconds, duration: 1.milliseconds);

  return tween;
}