abstract class AddressEntity {
  String name;
  String value;
  int id;

  AddressEntity({this.id, this.name, this.value});

  AddressEntity.fromJson(Map json) {
    this.name = json['name'];
    this.value = json['value'];
    this.id = json['id'];
  }

  copyWith({AddressEntity another}) {
    this.id = another.id;
    this.name = another.name;
    this.value = another.value;
  }
}
