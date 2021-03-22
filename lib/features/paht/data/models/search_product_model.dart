import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:citizen_app/features/paht/domain/entities/product_entity.dart';

class SearchProductModel {
  List<ProductModel> lstProduct;
  TonKhoModel tonKhoModel;

  SearchProductModel({this.lstProduct, this.tonKhoModel});

  factory SearchProductModel.fromJson(Map json) {
    return SearchProductModel(
     tonKhoModel: TonKhoModel.fromJson(json['tonKho']),
      lstProduct : json['lstProduct'] == null
          ? []
          : json['lstProduct'].map<ProductModel>((item) {
        ProductModel model = ProductModel.fromJson(item);
        return model;
      }).toList(),
    );
  }
}
