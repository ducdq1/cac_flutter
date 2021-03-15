abstract class CommentEntity {
  int parentId;
  String issueReportId;
  String updatedAt;
  int userId;
  String createdAt;
  String phoneNumber;
  int id;
  String content;
  List<CommentEntity> children = [];

  CommentEntity.fromJson(Map json) {
    this.id = int.tryParse(json['id'].toString());
    this.issueReportId = json['issueReportId'];
    this.updatedAt = json['updatedAt'];
    this.userId = int.tryParse(json['userId'].toString());
    this.parentId = json['parentId'];
    this.content = json['content'];
    this.createdAt = json['createdAt'];
    this.phoneNumber = json['phoneNumber'];
  }
}
