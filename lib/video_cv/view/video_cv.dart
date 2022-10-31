import 'package:flutter/material.dart';

class VideoCV extends StatefulWidget {
  const VideoCV({Key? key}) : super(key: key);

  @override
  State<VideoCV> createState() => _VideoCVState();
}

class _VideoCVState extends State<VideoCV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video CV'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[

          ]),
    );
  }
}
