import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_animation_demo/empty_page.dart';
import 'package:flutter_animation_demo/utils.dart';

import 'demo/001/time_back_animation_page.dart';
import 'demo/002/counter_animation_page.dart';
import 'demo/003/sliding_box_animation_page.dart';
import 'demo/004/widget_switch_animation_page.dart';
import 'demo/005/curves_test_animation_page.dart';
import 'demo/006/tween_builder_animation_page.dart';
import 'demo/007/animated_builder_demo_page.dart';
import 'demo/008/breathing_animation_page.dart';
import 'demo/009/snowflake_animation_page.dart';
import 'demo/010/water_wave_login_animation_page.dart';
import 'demo/011/left_side_menu_animation_page.dart';
import 'demo/012/bubbles_animation_login_page.dart';
import 'size_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static final routes = <RouteItem>[
    RouteItem("/001", desc: "倒计时动画", builder: (context) => TimeBackAnimationPage()),
    RouteItem("/002", desc: "翻滚数字动画", builder: (context) => CounterAnimationPage()),
    RouteItem("/003", desc: "方块交错动画", builder: (context) => SlidingBoxAnimationPage()),
    RouteItem("/004", desc: "小部件切换过渡动画", builder: (context) => WidgetSwitchAnimationPage()),
    RouteItem("/005", desc: "动画控件及曲线(Curves)", builder: (context) => CurvesTestAnimationPage()),
    RouteItem("/006", desc: "补间动画(TweenAnimationBuilder)", builder: (context) => TweenBuilderAnimationPage()),
    RouteItem("/007", desc: "万能的自定义动画(AnimatedBuilder)", builder: (context) => AnimatedBuilderDemoPage()),
    RouteItem("/008", desc: "478呼吸法动画", builder: (context) => BreathingAnimationPage()),
    RouteItem("/009", desc: "下雪堆雪人动画", builder: (context) => SnowflakeAnimationPage()),
    RouteItem("/010", desc: "水波浪动画登录页", builder: (context) => WaterWaveLoginAnimationPage()),
    RouteItem("/011", desc: "自定义动画效果边栏导航", builder: (context) => LeftSideMenuAnimationPage()),
    RouteItem("/012", desc: "气泡动画背景登录页", builder: (context) => BubblesAnimationLoginPage()),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: const Color(0xff000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: const Color(0x00000000),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));

    SizeUtils.init();

    final _routes = <String, WidgetBuilder>{};
    routes.map((e) => _routes[e.name] = e.builder);

    return MaterialApp(
      title: 'Flutter Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: Utils.fontFamily,
        dividerColor: const Color(0xffdddddd),
      ),
      // 多语言实现代理
      localizationsDelegates: [
        // LocalizationsCupertinoDelegate.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: Locale('zh', 'CH'),
      supportedLocales: [Locale('zh', 'CH')],
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Animation Demo'),
      onGenerateRoute: buildGenerateRoute(_routes),
    );
  }

  static RouteFactory buildGenerateRoute(Map<String, WidgetBuilder> routes) {
    return (settings) {
      final name = settings.name;
      final routeItem = settings.arguments is RouteItem
          ? settings.arguments as RouteItem : null;
      var widgetBuilder = routes[name] ?? routeItem.builder;
      if (widgetBuilder == null) {
        return MaterialPageRoute(
          builder: (context) => EmptyPage(
            desc: "找不到${routeItem?.desc ?? ""}示例。"),
          settings: settings,
        );
      }
      return MaterialPageRoute(
        builder: widgetBuilder,
        settings: settings,
      );
    };
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemExtent: 55,
        itemBuilder: (context, index) {
          final item = MyApp.routes[index];
          return ListTile(
            title: Text(item.desc ?? item.name),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12),
            leading: Text("${index + 1}", style: TextStyle(
              color: Colors.black38,
              fontFamily: Utils.fontFamily
            )),
            minLeadingWidth: 42,
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            onTap: () => Navigator.pushNamed(context, item.name, arguments: item),
          );
        },
        itemCount: MyApp.routes.length,
      )
    );
  }
}

class RouteItem {
  final String name;
  final String desc;
  final WidgetBuilder builder;
  const RouteItem(this.name, {this.desc, this.builder});
}