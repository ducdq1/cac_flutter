import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class TonKhoEntity extends Equatable {
  String sError;
  int so_luong;
  String dvt;
  String ten_vt;

  TonKhoEntity({this.sError, this.so_luong,this.dvt,this.ten_vt});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
