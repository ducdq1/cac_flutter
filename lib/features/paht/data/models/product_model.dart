import 'package:citizen_app/features/paht/data/models/image_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
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
      String createDate,
      List<ImageModel> images,
      String priceBLKM,
      String priceDL,
      String priceDLKM,
      String priceNHAPKM,
      String maDaiLy,
        String image,
      TonKhoModel tonKhoModel})
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
            images: images,
            createDate: createDate,
            priceBLKM: priceBLKM,
            priceDL: priceDL,
            priceDLKM: priceDLKM,
            priceNHAPKM: priceNHAPKM,
            maDaiLy: maDaiLy,
          image: image);

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
        createDate: json['createDate'],
        priceBLKM: json['priceBLKM'],
        priceDL: json['priceDL'],
        priceDLKM: json['priceDLKM'],
        priceNHAPKM: json['priceNHAPKM'],
        maDaiLy: json['maDaiLy'],
        image: json['image'],
        images: json['images'] == null
            ? []
            : json['images'].map<ImageModel>((item) {
                return ImageModel.fromJson(item);
              }).toList());
  }
}
