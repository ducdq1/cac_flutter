import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/media_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/place_images_entity.dart';
import 'package:citizen_app/features/paht/data/models/from_category_model.dart';
import 'package:equatable/equatable.dart';

class PahtEntity extends Equatable {
  int id;
  String name;
  double lat;
  double lng;
  int approveStatus;
  int userId;
  int poiId;
  int fromPoiType;
  int toPoiType;
  String address;
  String updatedDate;
  String createdDate;
  int action;
  String type;
  String phone;
  String hyperlink;
  List<BusinessHourEntity> businessHour;
  List<PlaceImagesEntity> placeImages;
  FromCategoryEntity fromCategory;
  PahtEntity(
      {this.id,
      this.name,
      this.lat,
      this.lng,
      this.approveStatus,
      this.userId,
      this.poiId,
      this.fromPoiType,
      this.toPoiType,
      this.address,
      this.updatedDate,
      this.createdDate,
      this.action,
      this.type,
      this.businessHour,
      this.placeImages,
        this.fromCategory,
        this.phone,
        this.hyperlink
      });

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
    type,
    businessHour,
    placeImages,
    phone,
    hyperlink,
    fromCategory
      ];

  Map<String, dynamic> toJson() {
    return {};
  }
}
