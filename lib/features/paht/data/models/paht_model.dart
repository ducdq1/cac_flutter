import 'package:citizen_app/features/paht/data/models/business_hour_model.dart';
import 'package:citizen_app/features/paht/data/models/place_images_model.dart';
import 'package:citizen_app/features/paht/domain/entities/paht_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';

class PahtModel extends PahtEntity {
  PahtModel(
      {int id,
      String name,
      double lat,
      double lng,
      int approveStatus,
      int userId,
      int poiId,
      int fromPoiType,
      int toPoiType,
      String address,
      int action,
      String updatedDate,
      String createdDate,
      List<BusinessHourModel> businessHour,
      List<PlaceImagesModel> placeImages,
        FromCategoryModel fromCategoryModel,
      String phone,
      String hyperlink
      })
      : super(
            id: id,
            name: name,
            lat: lat,
            lng: lng,
            approveStatus: approveStatus,
            userId: userId,
            poiId: poiId,
            fromPoiType: fromPoiType,
            toPoiType: toPoiType,
            address: address,
            updatedDate: updatedDate,
            createdDate: createdDate,
            action: action,
            businessHour: businessHour,
            placeImages: placeImages,
          fromCategory: fromCategoryModel,
            phone: phone,
      hyperlink: hyperlink);

  factory PahtModel.fromJson(Map json) {
    //MediaModel mediaJson = MediaModel.fromJson(json['mediaUrls']);
    return PahtModel(
        id: json['id'],
        name: json['name'],
        lat: json['lat'],
        lng: json['lng'],
        approveStatus: json['approveStatus'],
        userId: json['userId'],
        poiId: json['poiId'],
        fromPoiType: json['fromPoiType'],
        toPoiType: json['toPoiType'],
        address: json['address'],
        updatedDate: json['updatedDate'],
        createdDate: json['createdDate'],
        action: json['action'],
      fromCategoryModel: json['fromCategory'] == null
          ? null :
      FromCategoryModel.fromJson(json['fromCategory']),
        businessHour: json['businessHour'] == null
            ? []
            : json['businessHour'].map<BusinessHourModel>((item) {
          BusinessHourModel model = BusinessHourModel.fromJson(item);
                return model;
              }).toList(),
        placeImages: json['placeImages'] == null
            ? []
            : json['placeImages'].map<PlaceImagesModel>((item) {
                  PlaceImagesModel model =  PlaceImagesModel.fromJson(item);
                return model;
              }).toList(),
        phone : json['phone'],
      hyperlink : json['hyperlink'],
          );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'address': address,
      'lat': lat,
      'lng': lng,
      'approveStatus': approveStatus,
      'userId': userId,
      'poiId': poiId,
      'fromPoiType': fromPoiType,
      'toPoiType': toPoiType,
      'action': action,
      'hyperlink': hyperlink,
      'phone': phone,
      // 'businessHour': businessHour.toJson()
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        lat,
        lng,
        approveStatus,
        userId,
        poiId,
        fromPoiType,
        toPoiType,
        address,
        action,
        businessHour,
    placeImages,
      phone,
    hyperlink
      ];

  @override
  String toString() => '';
}
