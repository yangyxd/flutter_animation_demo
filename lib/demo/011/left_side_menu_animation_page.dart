import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/utils.dart';

/// 自定义动画效果边栏导航
/// https://www.bilibili.com/video/BV1Qo4y1R7qi?from=search&seid=16886666507962558427
class LeftSideMenuAnimationPage extends StatefulWidget {
  @override
  _LeftSideMenuAnimationPageState createState() =>
      _LeftSideMenuAnimationPageState();
}

class _LeftSideMenuAnimationPageState extends State<LeftSideMenuAnimationPage> {
  int selectMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/002.jpg"),
                  fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
          ),
          AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => showSideMenu()),
            actions: [IconButton(icon: Icon(Icons.auto_awesome), onPressed: () {})],
          ),
          Positioned(
            left: 50,
            right: 50,
            bottom: 75,
            height: 50,
            child: MaterialButton(
              child: Text("返回上一页", style: TextStyle(color: Colors.white54)),
              color: Colors.green.withOpacity(0.35),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          )
        ],
      ),
    );
  }

  showSideMenu() {
    SideMenu.showSideMenu(context, [
      Icon(Icons.animation),
      Icon(Icons.tag_faces),
      Icon(Icons.tag, size: 50),
      Icon(Icons.ac_unit_outlined),
      Icon(Icons.stream),
      Icon(Icons.account_circle_outlined),
      Icon(Icons.animation),
      Icon(Icons.tag_faces),
    ], selected: selectMenu, onItemSelected: (v) => selectMenu = v);
  }
}

/// 边栏导航菜单
class SideMenu extends StatefulWidget {
  final List<Widget> menus;
  final ValueChanged<int> onItemSelected;
  final Color selectedColor;
  final Color color;
  final double width;
  final double itemHeight;
  final int selected;

  const SideMenu({Key key,
    this.menus,
    this.selected,
    this.color,
    this.selectedColor,
    this.width,
    this.itemHeight,
    this.onItemSelected
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();

  /// 显示菜单
  static Future<T> showSideMenu<T>(BuildContext context,
      List<Widget> menus, {
      int selected,
      Color color,
      Color selectedColor,
      Color barrierColor,
      ValueChanged<int> onItemSelected,
  }) async {
    final page = SideMenu(menus: menus,
        selected: selected,
        color: color,
        selectedColor: selectedColor,
        onItemSelected: onItemSelected);
    final rote = FadePopupRoute<T>(page, backgroundColor: barrierColor);
    return await Navigator.push<T>(context, rote);
  }
}

class _SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  final itemAniTime = 300;
  AnimationController _controller;
  ScrollController _scrollerController;
  int _dCount = 1;
  bool _closeing = false;

  @override
  void initState() {
    _scrollerController = ScrollController();
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
    final _h = widget.itemHeight ?? 80;
    final _w = widget.width ?? 80;
    final _closeItemH = _h - 5.0 + _media.padding.top;
    final _expandH = _media.size.height -
        (_h * widget.menus.length) - _closeItemH;

    if (_controller == null) {
      // 计算出最多显示了多少个菜单
      _dCount = _expandH > 0
        ? widget.menus.length + 1
        : (_media.size.height - _closeItemH) ~/ _h + 1;
      if (_dCount < widget.menus.length + 1)
        _dCount++;
      // 根据最多显示的菜单数量，获得一个动画最大时间
      _controller = AnimationController(vsync: this,
          duration: Duration(milliseconds: min(_dCount * itemAniTime, 800))
      )..forward();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: _w,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0)
                        .chain(CurveTween(curve: Interval(0.5, 1.0)))
                        .animate(_controller),
                    child: Container(
                      color: (widget.color ?? Colors.white).withOpacity(0.15),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildItem(child: Padding(
                            padding: EdgeInsets.only(top: _media.padding.top),
                            child: IconButton(icon: Icon(Icons.close_outlined, size: 30),
                                tooltip: "关闭菜单",
                                onPressed: doClose)),
                            index: 0,
                            height: _closeItemH, width: _w),
                        Expanded(child: SingleChildScrollView(
                          controller: _scrollerController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i=0; i<widget.menus.length; i++)
                                buildItem(child: widget.menus[i],
                                    index: i+1,
                                    height: _h,
                                    width: _w,
                                    selected: i == widget.selected,
                                    onTap: () {
                                      doClose();
                                      if (widget.onItemSelected != null)
                                        widget.onItemSelected(i);
                                    }),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      onTap: doClose,
    );
  }

  Widget buildItem({Widget child,
    int index,
    double width, double height,
    bool selected,
    VoidCallback onTap}) {

    final _i = 1.0 / _dCount;
    final _reverse = _controller.status == AnimationStatus.reverse;
    final _animation = index < _dCount ? Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: !_reverse
          ? Interval(_i * index, _i * (index + 1))
          : Interval(_i * (_dCount - index - 1), _i * (_dCount - index))
        ))
        .animate(_controller) : null;

    // 使用缩放效果
    Widget _child = SizedBox(
      width: _animation == null
          ? width
          : min(width * _animation.value * 2.0, width),
      height: height,
      child: child,
    );
    if (onTap != null)
      _child = InkWell(onTap: onTap, child: _child);
    _child = Material(
      color: (selected == true
          ? (widget.selectedColor ?? Theme.of(context).primaryColorDark)
          : widget.color) ?? Colors.white.withOpacity(0.85),
      elevation: 0.0,
      child: selected == true ? IconTheme(
          data: IconThemeData(color: Theme.of(context).canvasColor),
          child: DefaultTextStyle(
            style: TextStyle(color: Theme.of(context).canvasColor),
            child: _child,
          )
      ) : _child,
    );
    if (_animation == null)
      return _child;
    // 增加一个3D的围绕Y轴旋转的动画效果
    return Transform(
        child: _child,
        alignment: Alignment.bottomLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(_reverse
              ? 1.0 - _animation.value
              : 1.0 - _animation.value
          )
    );
  }

  doClose() async {
    if (_closeing == true) return;
    _closeing = true;
    if (_scrollerController.position.pixels > 0)
      _scrollerController.jumpTo(0.0);
    _controller.duration = Duration(milliseconds: 500);
    await _controller.reverse(from: 1.0);
    Navigator.of(context).pop();
  }
}

class FadePopupRoute<T> extends PopupRoute<T> {
  final Widget widget;
  final Color backgroundColor;
  FadePopupRoute(this.widget, {this.backgroundColor});

  @override
  Color get barrierColor => backgroundColor ?? Colors.black54;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => "_SideMenuFadePopupRoute";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(context, animation, secondaryAnimation) =>
      MediaQuery.removePadding(context: context, child: widget);
}