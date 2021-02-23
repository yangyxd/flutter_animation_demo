import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class IconButtonEx<T> extends StatelessWidget {
  final Widget child;
  final Color color, focusColor;
  final double iconSize;
  final String tooltip;
  final bool autofocus;
  /// 菜单列表
  ///
  /// [[{'title': '分享', 'icon': FIcons.share_2, 'type': SHARE}]]
  final List<Map<String, dynamic>> menus;
  final Offset menuOffset;
  final MenusWidgetBuilder<T> menuItemBuilder;
  final T menuInitialValue;
  final T menuSelected;
  final double minWidth, splashRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;
  final ValueChanged<T> onSelected;

  const IconButtonEx({Key key, Widget child, Widget icon, this.color,
    this.focusColor, this.iconSize, this.tooltip,
    this.minWidth, this.splashRadius,
    this.autofocus,
    this.menus,
    this.menuOffset,
    this.menuItemBuilder,
    this.menuInitialValue,
    this.menuSelected,
    this.onSelected,
    this.padding, VoidCallback onPressed, VoidCallback onTap}):
      child = child ?? icon,
      onPressed = onPressed ?? onTap,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((menus != null && menus.isNotEmpty) || menuItemBuilder != null)
      return _buildButton(context, () {
        showButtonMenu(context,
          menus: menus,
          menuItemBuilder: menuItemBuilder,
          menuInitialValue: menuInitialValue,
          menuOffset: menuOffset,
          menuSelected: menuSelected,
          onSelected: onSelected
        );
      });
    return _buildButton(context, onPressed);
  }

  Widget _buildButton(BuildContext context, VoidCallback onPressed) {
    final _btn = IconButton(
      iconSize: iconSize ?? Theme.of(context).appBarTheme?.iconTheme?.size ?? 24,
      icon: child,
      autofocus: autofocus ?? false,
      focusColor: focusColor,
      tooltip: tooltip,
      color: color,
      splashRadius: splashRadius,
      padding: padding ?? const EdgeInsets.all(8.0),
      onPressed: onPressed,
    );
    return minWidth == null ? _btn : ButtonTheme(
      minWidth: minWidth,
      child: _btn,
    );
  }

  /// 显示弹出菜单
  static void showButtonMenu<T>(BuildContext context, {
    Offset menuOffset,
    Offset local,
    List<Map<String, dynamic>> menus,
    MenusWidgetBuilder<T> menuItemBuilder,
    T menuInitialValue,
    T menuSelected,
    ValueChanged<T> onSelected,
    VoidCallback onMenuCancel,
  }) {
    final mediaQueryData = MediaQueryData.fromWindow(ui.window);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = menuOffset ?? Offset(0, 40.0 / mediaQueryData.devicePixelRatio);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        local != null ? local : button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final _primaryColor = Theme.of(context).primaryColor;
    final _textStyle = Theme.of(context).popupMenuTheme?.textStyle ??
        Theme.of(context).textTheme.subtitle1;
    final List<PopupMenuEntry<T>> items = menuItemBuilder != null 
        ? menuItemBuilder(context)
        : menus.map((element) {
          final _value = element['type'];
          return PopupMenuItem<T>(
            textStyle: _textStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (menuSelected == _value)
                  ? DefaultTextStyle(
                    style: _textStyle.copyWith(color: _primaryColor),
                    child: Text(element['title']))
                  : Text(element['title']),
                if (element['icon'] != null)
                  Icon(element['icon'], color: _primaryColor, size: 20),
              ],
            ),
            value: _value,
          );
    }).toList();
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showMenu<T>(
        context: context,
        elevation: popupMenuTheme.elevation,
        items: items,
        position: position,
        shape: popupMenuTheme.shape,
        color: popupMenuTheme.color,
        initialValue: menuInitialValue,
      ).then<void>((T newValue) {
        if (newValue == null) {
          if (onMenuCancel != null) onMenuCancel();
          return null;
        }
        if (onSelected != null)
          onSelected(newValue);
        return newValue;
      });
    }
  }
}

typedef MenusWidgetBuilder<T> = List<PopupMenuEntry<T>> Function(BuildContext context);