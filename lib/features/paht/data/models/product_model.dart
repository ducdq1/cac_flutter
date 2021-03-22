import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/image_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:citizen_app/features/paht/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel(
      {int productId,
      String maHangHoa,
      String productName,
      String salePrice,
      String size,
      String unit,
      String feature,
      String dongGoi,
      String dsp,
      String madeIn,
      String productCode,
      String price,
      int productType,
      String color,
      List<ImageModel> imagesModel,
      List<String> images,
  TonKhoModel tonKhoModel}  )
      : super(
            productId: productId,
            maHangHoa: maHangHoa,
            productName: productName,
            salePrice: salePrice,
            size: size,
            unit: unit,
            feature: feature,
            dongGoi: dongGoi,
            dsp: dsp,
            madeIn: madeIn,
            productCode: productCode,
            price: price,
            productType: productType,
            color: color,
            imagesEntity: imagesModel,
            images: images);

  factory ProductModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return ProductModel(
        productId: json['productId'],
        maHangHoa: json['maHangHoa'],
        productName: json['productName'],
        salePrice: json['salePrice'],
        size: json['size'],
        unit: json['unit'],
        feature: json['feature'],
        dongGoi: json['dongGoi'],
        dsp: json['dsp'],
        madeIn: json['madeIn'],
        productCode: json['productCode'],
        price: json['price'],
        productType: json['productType'],
        color: json['color'],
        imagesModel: json['imagesModel'],
        images: json['images'] == null ? [] :
        json['images'].map<String>((item){
          return item.toString();
        }).toList()    );
  }
}
