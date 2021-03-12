import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/widgets/custom_animation.dart';
import 'package:flutter_animation_demo/widgets/timeline_tween/timeline_tween.dart';
import 'package:supercharged/supercharged.dart';

import 'plasma/plasma.dart';

class PlasmaAnimationPage extends StatelessWidget {
  final int flag;

  const PlasmaAnimationPage({Key key, this.flag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(context),
        AppBar(elevation: 0.0, backgroundColor: Colors.transparent),
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    var tween = _createTween();
    var size = MediaQuery.of(context).size;
    var ratio = size.width / size.height;

    return CustomAnimation(builder: (context, child, value) {
      return Positioned.fill(
        key: Key('p1'),
        child: AspectRatio(
          aspectRatio: ratio,
          child: flag == 1 ? _buildPlasma1(value) : _buildPlasma2(value),
        ),
      );
    }, tween: tween, duration: tween.duration);
  }

  Widget _buildPlasma1(TimelineValue<_P> value) {
    return FancyPlasmaWidget1(color: value.get<Color>(_P.p1Color));
  }

  Widget _buildPlasma2(TimelineValue<_P> value) {
    return FancyPlasmaWidget2(color: value.get<Color>(_P.p2Color));
  }
}

class OtherPlasma1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff7b1d17),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: PlasmaRenderer(
        type: PlasmaType.infinity,
        particles: 10,
        color: Color(0xd0110101),
        blur: 0.74,
        size: 0.87,
        speed: 10,
        offset: 0,
        blendMode: BlendMode.darken,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: -3.14,
      ),
    );
  }
}

class FancyPlasmaWidget1 extends StatelessWidget {
  const FancyPlasmaWidget1({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xfff44336),
            Color(0xff2196f3),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: PlasmaRenderer(
        type: PlasmaType.infinity,
        particles: 10,
        color: color,
        blur: 0.4,
        size: 1,
        speed: 6.35,
        offset: 0,
        blendMode: BlendMode.plus,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: 0,
      ),
    );
  }
}

class FancyPlasmaWidget2 extends StatelessWidget {
  const FancyPlasmaWidget2({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment(0.6, -1.0),
          end: Alignment(-0.3, 1.0),
          colors: [
            color.withOpacity(1.0),
            color.withOpacity(1.0),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: PlasmaRenderer(
        type: PlasmaType.infinity,
        particles: 20,
        color: color,
        blur: 0.5,
        size: 0.5830834600660535,
        speed: 3.916667302449544,
        offset: 0,
        blendMode: BlendMode.plus,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: 0,
      ),
    );
  }
}

const MUSIC_UNIT_MS = 6165;
enum _P { p1Scale, p2Scale, p1Color, p2Color }

TimelineTween<_P> _createTween() {
  var tween = TimelineTween<_P>();

  var red = Colors.red.withOpacity(0.4);
  var blue = Colors.blue.withOpacity(0.4);
  var yellow = Colors.yellow.shade800.withOpacity(0.4);
  var green = Colors.green.shade500.withOpacity(0.4);

  // B1 -> B2
  tween
      .addScene(
    duration: 200.milliseconds,
    begin: (0.25 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeIn,
  )
      .animate(_P.p1Color, tween: red.tweenTo(blue));

  // B2 -> B3
  tween
      .addScene(
    duration: 200.milliseconds,
    begin: (0.5 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeIn,
  )
      .animate(_P.p1Color, tween: blue.tweenTo(yellow));

  // B3 -> B4
  tween
      .addScene(
    duration: 200.milliseconds,
    begin: (0.75 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeIn,
  )
      .animate(_P.p1Color, tween: yellow.tweenTo(green));

  // Unit swap
  tween
      .addScene(
    begin: (0.75 * MUSIC_UNIT_MS).round().milliseconds,
    duration: 500.milliseconds,
    curve: Curves.easeInOut,
  )
      .animate(_P.p1Scale, tween: 1.0.tweenTo(0.5));
  tween
      .addScene(
      duration: 500.milliseconds,
      begin: (1.0 * MUSIC_UNIT_MS).round().milliseconds,
      curve: Curves.easeInOut)
      .animate(
    _P.p2Scale,
    tween: 0.5.tweenTo(1.0),
  );

  // B1 -> B2 (no gong)
  tween
      .addScene(
    begin: (1.2 * MUSIC_UNIT_MS).round().milliseconds,
    end: (1.3 * MUSIC_UNIT_MS).round().milliseconds,
  )
      .animate(_P.p2Color, tween: green.tweenTo(red));

  // B2 -> B3
  tween
      .addScene(
    duration: 200.milliseconds,
    begin: (1.5 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeIn,
  )
      .animate(_P.p2Color, tween: red.tweenTo(blue));

  // B3 -> B4
  tween
      .addScene(
    duration: 200.milliseconds,
    begin: (1.75 * MUSIC_UNIT_MS).round().milliseconds,
    curve: Curves.easeIn,
  )
      .animate(_P.p2Color, tween: blue.tweenTo(yellow));

  tween.addScene(
      end: (2 * MUSIC_UNIT_MS).milliseconds, duration: 1.milliseconds);

  return tween;
}

