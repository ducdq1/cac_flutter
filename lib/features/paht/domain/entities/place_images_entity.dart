import 'package:equatable/equatable.dart';

class PlaceImagesEntity extends Equatable {
   final String imageThumbUrl;
   final String imageUrl;
   final int id;
   final int approveStatus;

  PlaceImagesEntity({this.id, this.imageUrl, this.imageThumbUrl,this.approveStatus});

  @override
  List<Object> get props => [id, imageUrl, imageThumbUrl,approveStatus];
  Map<String, dynamic> toJson() {
    return {};
  }
}
