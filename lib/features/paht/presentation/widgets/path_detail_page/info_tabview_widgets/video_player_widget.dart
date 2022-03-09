import 'package:chewie/chewie.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../appbar_heading_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String fileName;
  VideoPlayerWidget({this.url,this.fileName});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
   var videoPlayerController ;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.url);
    await videoPlayerController.initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
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
          widget.fileName??"",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: FONT_EX_LARGE,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Chewie(
          controller: ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: true
          ),
        ),
      ),
    );
  }
}
