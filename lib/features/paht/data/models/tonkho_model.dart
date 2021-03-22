import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:citizen_app/features/paht/domain/entities/product_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/tonkho_entity.dart';

class TonKhoModel extends TonKhoEntity {
  TonKhoModel({
    String sError,
    int so_luong,
    String dvt,
    String ten_vt,
  }) : super(sError: sError, so_luong: so_luong, dvt: dvt, ten_vt: ten_vt);

  factory TonKhoModel.fromJson(Map json) {
    return TonKhoModel(
      sError: json['sError'],
      so_luong: json['so_luong'],
      dvt: json['dvt'],
      ten_vt: json['ten_vt'],
    );
  }
}
