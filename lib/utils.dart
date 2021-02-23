import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {

  const Utils._();

  /// 默认字体
  static final String fontFamily = Platform.isWindows || Platform.isMacOS
      ? 'Roboto' : '';

  /// 运行模式： true 为 debug 模式
  static const bool isAppDebug =
    !(const bool.fromEnvironment("dart.vm.product"));

  static bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  /// 当前时间戳（毫秒）
  static int get currentTimestamp => DateTime.now().millisecondsSinceEpoch;

  /// 延时指定毫秒
  static sleep(int milliseconds, [VoidCallback onEvent]) async {
    await Future.delayed(Duration(milliseconds: milliseconds), onEvent);
  }

  /// 开始一个页面，并等待结束
  static Future<Object> startPageWait(BuildContext context, Widget page,
      {bool replace}) async {
    if (page == null) return null;
    var rote = Platform.isIOS
        ? CupertinoPageRoute(builder: (context) => page)
        : MaterialPageRoute(builder: (_) => page);
    if (replace == true) return await Navigator.pushReplacement(context, rote);
    return await Navigator.push(context, rote);
  }

  /// 生成随机数
  static int random(int max) {
    return Random().nextInt(max) + 1;
  }

  static String randomCode([int len=8]) {
    final String chars = "0123456789abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWXYZa";
    String result = '';
    for (int i=0; i<len; i++) {
      final j = random(chars.length - 1);
      result += chars.substring(j, j+1);
    }
    return result;
  }

  static String uuid() {
    final t = currentTimestamp.toString();
    return randomCode(18) + t.substring(t.length - 6) + randomCode(8);
  }

  /// 判断字符串是否为空
  static bool empty(String src) {
    return src == null || src.isEmpty;
  }

  /// 列表转化
  static List<T> toList<T, E>(List<E> source, T generator(E v)) {
    var items = <T>[];
    if (source != null && source.isNotEmpty) {
      for (final e in source)
        items.add(generator(e));
    }
    return items;
  }

}