import 'dart:math';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_demo/model/dao.dart';

/// 插画长廊页面过渡动画效果
class ImageHeroAnimationPage extends StatefulWidget {
  @override
  _ImageHeroAnimationPageState createState() => _ImageHeroAnimationPageState();
}

class _ImageHeroAnimationPageState extends State<ImageHeroAnimationPage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  List<HeroImageItem> items;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    final _random = Random();
    items = List<HeroImageItem>.generate(50, (index) => HeroImageItem(
      url: Dao.images[_random.nextInt(Dao.images.length - 1)],
      title: "插画-${index+1}",
      desc: Dao.imageDesc[_random.nextInt(Dao.imageDesc.length - 1)],
    ));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.yellow,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("插画长廊"),
        ),
        body: GridView.builder(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 4),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              childAspectRatio: 0.75,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: items.length,
            itemBuilder: _buildItem
        ),
      ),
    );
  }

  Widget _buildItem(context, index) {
    // final _tag = "$index,"+ items[index].url;
    return OpenContainer(
      closedElevation: 0.0,
      openElevation: 8.0,
      transitionDuration: Duration(milliseconds: 750),
      openBuilder: (context, _) {
        return ImageDescViewPage(image: items[index]);
      },
      closedBuilder: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CachedNetworkImage(
            imageUrl: items[index].url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          )),
          SizedBox(height: 8),
          Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(items[index].title, style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              ))),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: Text(items[index].desc, style: TextStyle(
              fontSize: 14,
            ), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class HeroImageItem {
  final String url;
  final String title;
  final String desc;
  const HeroImageItem({this.url, this.title, this.desc});
}

/// 插画详情
class ImageDescViewPage extends StatelessWidget {
  final HeroImageItem image;

  const ImageDescViewPage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.black,
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("插画详情"),
              floating: true,
              expandedHeight: 320,
              flexibleSpace: CachedNetworkImage(
                imageUrl: image.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
              ),
            ),
            SliverToBoxAdapter(child: buildColumn())
          ],
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(image.title, style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                    ))),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text((image.desc + "\n") * 10, style: TextStyle(
                    fontSize: 14,
                    height: 1.8,
                  )),
                ),
                SizedBox(height: 300),
              ],
            );
  }
}

