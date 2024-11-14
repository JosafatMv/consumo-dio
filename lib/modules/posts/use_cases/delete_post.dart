import 'package:consumo/modules/posts/entities/post_entity.dart';
import 'package:consumo/modules/posts/repositories/post_repository.dart';

class DeletePost {
  final PostRepository repository;
  DeletePost({required this.repository});

  Future<void> call(int postId) async {
    return repository.deletePost(postId);
  }
}
