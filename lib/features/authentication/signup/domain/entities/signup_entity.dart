import 'package:citizen_app/features/authentication/signup/data/models/signup_model.dart';

abstract class SignUpEntity {
  String phone;
  String password;
  String name;
  String dob;
  int gender;
  String email;
  String identityNo;
  String permanentAddress;
  String permanentProvince;
  String permanentDistrict;
  String permanentWard;
  String permanentProvinceName;
  String permanentDistrictName;
  String permanentWardName;

  String currentAddress;
  String currentProvince;
  String currentDistrict;
  String currentWard;

  String currentProvinceName;
  String currentDistrictName;
  String currentWardName;
  String captchaId;
  String captcha;

  // SignUpEntity(
  //   {
  //     this.phone,
  //     this.password,
  //     this.name,
  //     this.identityNo,
  //     this.email,
  //     this.dob,
  //     this.gender,
  //     this.permanentAddress,
  //     this.permanentProvince,
  //     this.permanentDistrict,
  //     this.permanentWard,
  //     this.currentAddress,
  //     this.currentProvince,
  //     this.currentDistrict,
  //     this.currentWard,
  //     this.captchaId,
  //     this.captcha,
  //   }
  // );

  copyWith(SignUpEntity another) {
    final copy = SignUpModel();
    copy.password = another.password ?? this.password;
    copy.phone = another.phone ?? this.phone;
    copy.name = another.name ?? this.name;
    copy.identityNo = another.identityNo ?? this.identityNo;
    copy.email = another.email ?? this.email;
    copy.dob = another.dob ?? this.dob;
    copy.gender = another.gender ?? this.gender;
    copy.permanentAddress = another.permanentAddress ?? this.permanentAddress;
    copy.permanentProvince =
        another.permanentProvince ?? this.permanentProvince;
    copy.permanentDistrict =
        another.permanentDistrict ?? this.permanentDistrict;
    copy.permanentWard = another.permanentWard ?? this.permanentWard;
    copy.currentAddress = another.currentWard ?? this.currentAddress;
    copy.currentProvince = another.currentProvince ?? this.currentProvince;
    copy.currentDistrict = another.currentDistrict ?? this.currentDistrict;
    copy.currentWard = another.currentWard ?? this.currentWard;
    copy.captchaId = another.captchaId ?? this.captchaId;
    copy.captcha = another.captcha ?? this.captcha;
    return copy;
  }

  toJson() {
    return {
      "username": this.phone,
      "password": this.password,
      "phone": this.phone,
      "customerName": this.name,
      "customerType": 1,
      "identityNo": this.identityNo,
      "email": this.email,
      "dob": this.dob,
      "gender": this.gender,
      "permanentAddress": this.permanentAddress,
      "permanentProvince": this.permanentProvince,
      "permanentDistrict": this.permanentDistrict,
      "permanentWard": this.permanentWard,
      "currentAddress": this.currentAddress,
      "currentProvince": this.currentProvince,
      "currentDistrict": this.currentDistrict,
      "currentWard": this.currentWard,
      "taxCode": "",
      "representativeName": "",
      "activeType": "1",
      "captchaId": this.captchaId,
      "captcha": this.captcha,
    };
  }
}
