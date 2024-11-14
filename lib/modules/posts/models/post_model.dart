
import '../entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required id,
    required title,
    required body,
    required userId,
  }) : super(id: id, title: title, body: body, userId: userId);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
    };
  }
}