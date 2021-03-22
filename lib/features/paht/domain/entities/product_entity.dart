import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/image_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  int productId;
  String maHangHoa;
  String productName;
  String salePrice;
  String size;
  String unit;
  String feature;
  String dongGoi;
  String dsp;
  String madeIn;
  String productCode;
  String price;
  int productType;
  String color;
  List<ImageEntity> imagesEntity;
  List<String> images;
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  ProductEntity({
      this.productId,
      this.maHangHoa,
      this.productName,
      this.salePrice,
      this.size,
      this.unit,
      this.feature,
      this.dongGoi,
      this.dsp,
      this.madeIn,
      this.productCode,
      this.price,
      this.productType,
      this.color,
      this.imagesEntity,
  this.images});
}
