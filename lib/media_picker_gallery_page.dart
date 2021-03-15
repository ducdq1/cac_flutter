import 'package:flutter/material.dart';

class MediaPickerGalleryPageTest extends StatefulWidget {
  @override
  _MediaPickerGalleryPageState createState() => _MediaPickerGalleryPageState();
}

class _MediaPickerGalleryPageState extends State<MediaPickerGalleryPageTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Native view')),
      body: Center(
        child: SizedBox(
          width: 380,
          height: 380,
          child: UiKitView(
            viewType: 'mediaPickerView',
          ),
        ),
      ),
    );
  }
}
