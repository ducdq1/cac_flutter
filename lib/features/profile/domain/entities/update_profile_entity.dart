import 'dart:convert';

abstract class UpdateProfileEntity {
  bool isViettelAuth = false;
  int userId;
  String customerName;
  String identityNo;
  String phone;
  int gender;
  String dob;
  String email;
  String currentAddress;
  String permanentAddress;
  String permanentProvince;
  String permanentDistrict;
  String permanentWard;
  String currentProvince;
  String currentDistrict;
  String currentWard;

  UpdateProfileEntity.fromJson(Map json) {
    this.userId = json['userId'];
    this.customerName = json['customerName'];
    this.phone = json['phone'];
    this.email = json['email'];
    this.gender = json['gender'];
    this.dob = json['dob'];
    this.identityNo = json['identityNo'];
    this.permanentAddress = json['permanentAddress'];
    this.currentAddress = json['currentAddress'];
    this.permanentProvince = json['permanentProvince'];
    this.permanentDistrict = json['permanentDistrict'];
    this.permanentWard = json['permanentWard'];
    this.currentProvince = json['currentProvince'];
    this.currentDistrict = json['currentDistrict'];
    this.currentWard = json['currentWard'];
  }

  toJson() {
    return {
      'userId': userId,
      'customerName': customerName,
      'customerType': 1,
      'phone': phone,
      'email': email,
      'gender': gender,
      'dob': dob,
      'permanentAddress': permanentAddress,
      'currentAddress': currentAddress,
      'permanentProvince': permanentProvince,
      'permanentDistrict': permanentDistrict,
      'permanentWard': permanentWard,
      'currentProvince': currentProvince,
      'currentDistrict': currentDistrict,
      'currentWard': currentWard,
      'identityNo': this.identityNo,
      'representativeName': '',
      'activeAccountType': 1
    };
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
