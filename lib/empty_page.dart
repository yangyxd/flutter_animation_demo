import 'package:flutter/material.dart';
import 'utils.dart';

class EmptyPage extends StatefulWidget {
  final String title;
  final String desc;

  const EmptyPage({Key key, this.title, this.desc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title ?? "页面不存在")),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.tag_faces, size: 96, color: Colors.black12),
              SizedBox(height: 16),
              Text(widget.desc ?? "", style: TextStyle(
                color: const Color(0xff666666),
                fontFamily: Utils.fontFamily,
                fontSize: 14.0
              ))
            ],
          ),
        )
    );
  }
}
