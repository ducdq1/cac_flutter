import 'dart:io';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/presentation/pages/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class ListViewVideoItemWidget extends StatefulWidget {
  final String url;

  ListViewVideoItemWidget({this.url});
  @override
  _ListViewVideoItemWidgetState createState() =>
      _ListViewVideoItemWidgetState();
}

class _ListViewVideoItemWidgetState extends State<ListViewVideoItemWidget> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      // widget.url ??
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 280,
          height: 160,
          color: Colors.black,
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: _controller.value.isPlaying
                          ? SvgPicture.asset(SVG_ASSETS_PATH + 'icon_play.svg')
                          : SvgPicture.asset(
                              SVG_ASSETS_PATH + 'icon_pause.svg',
                            ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerPage(url: null),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.aspect_ratio_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  backgroundColor: Colors.white,
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
