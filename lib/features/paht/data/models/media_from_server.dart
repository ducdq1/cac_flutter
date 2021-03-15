import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MediaFromServer {
  final int id;
  final String type;
  final String url;
  final String relUrl;
  final Asset asset;

  MediaFromServer({this.type, this.url, @required this.relUrl,this.id,this.asset});
}
