import 'package:consumo/modules/posts/entities/post_entity.dart';
import 'package:consumo/modules/posts/repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost({required this.repository});

  Future<PostEntity> call(PostEntity user) async {
    return await repository.createPost(user);
  }
}