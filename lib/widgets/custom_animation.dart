import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:supercharged/supercharged.dart';

typedef AnimatedWidgetBuilder<T> = Widget Function(
    BuildContext context, Widget child, T value);

/// 自定义动画
class CustomAnimation<T> extends StatefulWidget {
  final AnimatedWidgetBuilder<T> builder;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final Animatable<T> tween;
  final CustomAnimationControl control;
  final double from;
  final AnimationStatusListener animationStatusListener;

  const CustomAnimation({
    Key key,
    this.control = CustomAnimationControl.PLAY,
    @required this.builder,
    @required this.tween,
    this.from = 0.0,
    this.child,
    this.duration = const Duration(seconds: 1),
    this.delay = Duration.zero,
    this.curve = Curves.linear,
    this.animationStatusListener,
  }) : assert(tween != null,
          'Please set property tween. Example:\ntween: Tween(from: 0.0, to: 100.0)'),
       super(key: key);

  /// 循环动画
  const CustomAnimation.loop({
    Key key,
    @required this.builder,
    @required this.tween,
    this.duration = const Duration(seconds: 1),
    this.delay = Duration.zero,
    this.curve = Curves.linear,
    this.animationStatusListener,
    this.child,
  }): control = CustomAnimationControl.LOOP,
      from = 0.0,
      super(key: key);

  @override
  _CustomAnimationState createState() => _CustomAnimationState<T>();
}

class _CustomAnimationState<T> extends State<CustomAnimation<T>> with AnimationMixin {
  AnimationController _controller;
  Animation<T> _animation;
  bool _isDisposed = false;
  bool _waitForDelay = true;
  bool _isControlSetToMirror = false;

  @override
  void initState() {
    _controller = createController();
    _controller.value = widget.from;
    _controller.duration = widget.duration;

    _buildAnimation();

    if (widget.animationStatusListener != null) {
      _controller.addStatusListener(widget.animationStatusListener);
    }

    asyncInitState();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _buildAnimation() {
    _animation = widget.tween.curved(widget.curve).animatedBy(_controller);
  }

  void asyncInitState() async {
    if (widget.delay != null) {
      await Future<void>.delayed(widget.delay);
    }
    _waitForDelay = false;
    _applyControlInstruction();
  }

  void _applyControlInstruction() async {
    if (_isDisposed || _waitForDelay) {
      return;
    }

    if (widget.control == CustomAnimationControl.STOP) {
      _controller.stop();
    }
    if (widget.control == CustomAnimationControl.PLAY) {
      _controller.play();
    }
    if (widget.control == CustomAnimationControl.PLAY_REVERSE) {
      _controller.playReverse();
    }
    if (widget.control == CustomAnimationControl.PLAY_FROM_START) {
      _controller.forward(from: 0.0);
    }
    if (widget.control == CustomAnimationControl.PLAY_REVERSE_FROM_END) {
      _controller.reverse(from: 1.0);
    }
    if (widget.control == CustomAnimationControl.LOOP) {
      _controller.loop();
    }
    if (widget.control == CustomAnimationControl.MIRROR &&
        !_isControlSetToMirror) {
      _isControlSetToMirror = true;
      _controller.mirror();
    }

    if (widget.control != CustomAnimationControl.MIRROR) {
      _isControlSetToMirror = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child, _animation.value);
  }
}

enum CustomAnimationControl {
  /// Stops the animation at the current position.
  STOP,

  /// Plays the animation from the current position to the end.
  PLAY,

  /// Plays the animation from the current position reverse to the start.
  PLAY_REVERSE,

  /// Reset the position of the animation to `0.0` and starts playing
  /// to the end.
  PLAY_FROM_START,

  /// Reset the position of the animation to `1.0` and starts playing
  /// reverse to the start.
  PLAY_REVERSE_FROM_END,

  /// Endlessly plays the animation from the start to the end.
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  LOOP,

  /// Endlessly plays the animation from the start to the end, then
  /// it plays reverse to the start, then forward again and so on.
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  MIRROR
}

/// Method extensions on [AnimationController]
extension AnimationControllerExtension on AnimationController {
  /// Starts playing the animation in forward direction.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  ///
  /// Returns a [TickerFuture] that completes when the animation ends or
  /// get canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.play(5.seconds);
  /// ```
  TickerFuture play({Duration duration}) {
    this.duration = duration ?? this.duration;
    return forward();
  }

  /// Starts playing the animation in backward direction.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  ///
  /// Returns a [TickerFuture] that completes when the animation ends or
  /// get canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.playReverse(5.seconds);
  /// ```
  TickerFuture playReverse({Duration duration}) {
    this.duration = duration ?? this.duration;
    return reverse();
  }

  /// Starts playing the animation in an endless loop. After reaching the
  /// end, it starts over from the beginning.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  /// The [duration] applies to the length of one loop iteration.
  ///
  /// Returns a [TickerFuture] that only completes when the animation gets
  /// canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.loop(5.seconds);
  /// ```
  TickerFuture loop({Duration duration}) {
    this.duration = duration ?? this.duration;
    return repeat();
  }

  /// Starts playing the animation in an endless loop. After reaching the
  /// end, it plays it backwards, then forward and so on.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  /// The [duration] applies to the length of one loop iteration.
  ///
  /// Returns a [TickerFuture] that only completes when the animation gets
  /// canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.mirror(5.seconds);
  /// ```
  TickerFuture mirror({Duration duration}) {
    this.duration = duration ?? this.duration;
    return repeat(reverse: true);
  }
}

class _AnimationControllerTransfer extends InheritedWidget {
  final void Function(AnimationController) controllerProvider;

  _AnimationControllerTransfer({
    Key key,
    this.controllerProvider,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant _AnimationControllerTransfer oldWidget) {
    return oldWidget.controllerProvider != controllerProvider;
  }
}

mixin AnimationMixin<T extends StatefulWidget> on State<T> implements TickerProvider {
  AnimationController _mainControllerInstance;

  final _controllerInstances = <AnimationController>[];

  /// Returns the main [AnimationController] instance for this state class.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
  ///     with AnimationMixin {  // Add AnimationMixin to state class
  ///
  ///   Animation<double> size; // Declare animation variable
  ///
  ///   @override
  ///   void initState() {
  ///     size = 0.0.tweenTo(200.0).animatedBy(controller); // Connect tween and controller and apply to animation variable
  ///     controller.play(); // Start the animation playback
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Container(
  ///         width: size.value, // Use animation variable's value here
  ///         height: size.value, // Use animation variable's value here
  ///         color: Colors.red
  ///     );
  ///   }
  /// }
  /// ```
  AnimationController get controller {
    _mainControllerInstance ??= _newAnimationController();
    return _mainControllerInstance;
  }

  /// Connects given [controller] to the closest [AnimationDeveloperTools]
  /// widget to enable developer mode.
  void enableDeveloperMode(AnimationController controller) {
    var transfer =
    context.findAncestorWidgetOfExactType<_AnimationControllerTransfer>();
    assert(transfer != null,
    'Please place an AnimationDeveloperTools widget inside the widget tree');
    transfer.controllerProvider(controller);
  }

  /// Creates an additional [AnimationController] instance that gets initialized
  /// and disposed by this mixin.
  ///
  /// Optionally you can limit the framerate (fps) by specifying a target [fps]
  /// value.
  ///
  /// You can create an unbound [AnimationController] by setting the [unbounded]
  /// parameter.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
  ///     with AnimationMixin { // <-- use AnimationMixin
  ///
  ///   AnimationController sizeController; // <-- declare custom AnimationController
  ///   Animation<double> size;
  ///
  ///   @override
  ///   void initState() {
  ///     sizeController = createController(); // <-- create custom AnimationController
  ///     size = 0.0.tweenTo(100.0).animatedBy(sizeController); // <-- animate "size" with custom AnimationController
  ///     sizeController.play(duration: 5.seconds); // <-- start playback on custom AnimationController
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Container(width: size.value, height: size.value, color: Colors.red);
  ///   }
  /// }
  /// ```
  AnimationController createController({
    bool unbounded = false,
    int fps,
  }) {
    final instance = _newAnimationController(unbounded: unbounded, fps: fps);
    _controllerInstances.add(instance);
    return instance;
  }

  AnimationController _newAnimationController({
    bool unbounded = false,
    int fps,
  }) {
    var controller = _instanceController(unbounded: unbounded);

    if (fps == null) {
      controller.addListener(() => setState(() {}));
    } else {
      _addFrameLimitingUpdater(controller, fps);
    }

    return controller;
  }

  void _addFrameLimitingUpdater(AnimationController controller, int fps) {
    var lastUpdateEmitted = DateTime(1970);
    final frameTimeMs = (1000 / fps).floor();

    controller.addListener(() {
      final now = DateTime.now();
      if (lastUpdateEmitted.isBefore(now.subtract(frameTimeMs.milliseconds))) {
        lastUpdateEmitted = DateTime.now();
        setState(() {});
      }
    });
  }

  AnimationController _instanceController({bool unbounded}) {
    if (!unbounded) {
      return AnimationController(vsync: this, duration: 1.seconds);
    } else {
      return AnimationController.unbounded(vsync: this, duration: 1.seconds);
    }
  }

  // below code from TickerProviderStateMixin (dispose method is modified) ----------------------------------------

  Set<Ticker> _tickers;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _tickers ??= <_WidgetTicker>{};
    // ignore: omit_local_variable_types
    final _WidgetTicker result =
    _WidgetTicker(onTick, this, debugLabel: 'created by $this');
    _tickers.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers.contains(ticker));
    _tickers.remove(ticker);
  }

  @override
  void dispose() {
    // Added disposing for created entities
    if (_mainControllerInstance != null) {
      _mainControllerInstance.dispose();
    }
    _controllerInstances.forEach((instance) => instance.dispose());
    // Original dispose code
    assert(() {
      if (_tickers != null) {
        // ignore: omit_local_variable_types
        for (Ticker ticker in _tickers) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                  '$runtimeType created a Ticker via its TickerProviderStateMixin, but at the time '
                      'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
                      'be disposed before calling super.dispose().'),
              ErrorHint('Tickers used by AnimationControllers '
                  'should be disposed by calling dispose() on the AnimationController itself. '
                  'Otherwise, the ticker will leak.'),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // ignore: omit_local_variable_types
    final bool muted = !TickerMode.of(context);
    if (_tickers != null) {
      // ignore: omit_local_variable_types
      for (Ticker ticker in _tickers) {
        ticker.muted = muted;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Set<Ticker>>(
      'tickers',
      _tickers,
      description: _tickers != null
          ? 'tracking ${_tickers.length} ticker${_tickers.length == 1 ? "" : "s"}'
          : null,
      defaultValue: null,
    ));
  }
}

// This class should really be called _DisposingTicker or some such, but this
// class name leaks into stack traces and error messages and that name would be
// confusing. Instead we use the less precise but more anodyne "_WidgetTicker",
// which attracts less attention.
class _WidgetTicker extends Ticker {
  _WidgetTicker(TickerCallback onTick, this._creator, {String debugLabel})
      : super(onTick, debugLabel: debugLabel);

  final AnimationMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
