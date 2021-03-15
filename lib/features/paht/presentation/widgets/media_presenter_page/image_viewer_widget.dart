import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerWidget extends StatelessWidget {
  final String url;
  ImageViewerWidget({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: url,
        child: PhotoView(
          imageProvider: NetworkImage(
            url,
          ),
        ),
      ),
    );
  }
}
