import 'dart:typed_data';

import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/presentation/widgets/media_presenter_page/image_viewer_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/media_presenter_page/preview_image_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';
import 'package:citizen_app/features/paht/data/models/media_model.dart';

const PADDING_CONTENT_HORIZONTAL = 16.0;
const SIZE_ARROW_BACK_ICON = 24.0;

class MediaPresenterPage extends StatefulWidget {
  final List<PlaceImagesModel> urls;
  final bool isPhoto;
  final int initialIndex;

  MediaPresenterPage({this.urls, this.isPhoto = true, this.initialIndex = 0});

  @override
  _MediaPresenterPageState createState() => _MediaPresenterPageState();
}

class _MediaPresenterPageState extends State<MediaPresenterPage>
    with TickerProviderStateMixin {
  TabController _controller;
  int _currentIndex;

  _shareMedia() async {
    await Share.share('${widget.urls[_currentIndex]}');
  }

  _saveImageToGallery() async {
    var response = await Dio().get('${widget.urls[_currentIndex]}',
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 80,
      name: DateTime.now().toUtc().toString(),
    );
    print(result);
  }

  @override
  void initState() {
    _controller = TabController(
      initialIndex: widget.initialIndex,
      vsync: this,
      length: widget.urls.length,
    );
    _currentIndex = _controller.index;
    _controller.addListener(() {
      if (_controller.index != _currentIndex) {
        setState(() {
          _currentIndex = _controller.index;
        });
      }
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          trans(PHOTO_INFO),
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: FONT_EX_LARGE,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_share.svg',
              width: SIZE_ARROW_BACK_ICON,
              height: SIZE_ARROW_BACK_ICON,
            ),
            onPressed: () {
              _shareMedia();
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_download.svg',
              width: SIZE_ARROW_BACK_ICON,
              height: SIZE_ARROW_BACK_ICON,
            ),
            onPressed: () {
              _saveImageToGallery();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: widget.urls
                    .map((url) => ImageViewerWidget(url: url.imageUrl))
                    .toList(),
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: Text(
                '${_currentIndex + 1}/${_controller.length}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: FONT_MIDDLE,
                ),
              ),
            ),
            SizedBox(height: 35),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 34),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return false;
                  },
                  child: TabBar(
                    isScrollable: true,
                    controller: _controller,
                    indicatorColor: Colors.transparent,
                    physics: ClampingScrollPhysics(),
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicatorWeight: 1,
                    indicator: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    tabs: widget.urls
                        .map((url) => PreviewImageWidget(url: url.imageUrl))
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
