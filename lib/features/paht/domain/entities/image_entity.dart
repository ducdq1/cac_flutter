import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  int attachId;
  String path;
  String name;
  ImageEntity({this.attachId, this.path,this.name});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
