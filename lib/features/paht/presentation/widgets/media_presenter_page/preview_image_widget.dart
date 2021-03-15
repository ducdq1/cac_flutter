import 'package:flutter/material.dart';

class PreviewImageWidget extends StatelessWidget {
  final String url;
  final bool isActive;
  PreviewImageWidget({this.isActive = false, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Image.network(
          url,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
