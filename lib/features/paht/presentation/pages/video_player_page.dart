import 'package:chewie/chewie.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

const SIZE_ARROW_BACK_ICON = 24.0;

class VideoPlayerPage extends StatefulWidget {
  final String url;
  final String title;
  VideoPlayerPage({this.url, this.title});
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  Future<void> _initPlayer() async {
    _controller = VideoPlayerController.network(
      widget.url ??
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );

    await _controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      // aspectRatio: _controller.value.aspectRatio,
      autoPlay: true,
      autoInitialize: true,
      allowFullScreen: false,
      allowMuting: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(platform: TargetPlatform.iOS),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_arrow_back.svg',
              width: SIZE_ARROW_BACK_ICON,
              height: SIZE_ARROW_BACK_ICON,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.title ?? 'Video',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: FONT_EX_LARGE,
              fontWeight: FontWeight.bold,
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: SvgPicture.asset(
          //       SVG_ASSETS_PATH + 'icon_share.svg',
          //       width: SIZE_ARROW_BACK_ICON,
          //       height: SIZE_ARROW_BACK_ICON,
          //     ),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: _chewieController != null &&
                _chewieController.videoPlayerController.value.initialized
            ? Chewie(
                controller: _chewieController,
              )
            : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  backgroundColor: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: PRIMARY_COLOR,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    super.dispose();
  }
}
