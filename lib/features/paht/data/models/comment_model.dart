import 'package:citizen_app/features/paht/data/models/subcomment_model.dart';
import 'package:citizen_app/features/paht/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel.fromJson(Map json) : super.fromJson(json['comment']) {
    this.children = (json['replies'] as List)
        .map((cmt) => SubCommentModel.fromJson(cmt))
        .toList();
  }
}
