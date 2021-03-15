import 'dart:convert';

abstract class UserEntity {
 String address;
  String avatarThumbUrl;
 String  avatarUrl;
 String birthday;
 String email;
 String  fullName;
 int id;
 String phone;
 String userName;

 UserEntity.fromJson(Map json) {
    this.address = json['address'];
    this.userName = json['userName'];
    this.avatarThumbUrl = json['avatarThumbUrl'];
    this.phone = json['phone'];
    this.email = json['email'];
    this.fullName = json['fullName'];
    this.birthday = json['birthday'];
    this.avatarUrl = json['avatarUrl'];
    this.id = json['id'];
  }

  toJson() {
    return {
      'address': address,
      'userName': userName,
      'avatarThumbUrl': avatarThumbUrl,
      'phone': phone,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'birthday': birthday,
      'id': id
    };
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
