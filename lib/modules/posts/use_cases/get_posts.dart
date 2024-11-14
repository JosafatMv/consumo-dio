import 'package:consumo/modules/posts/entities/post_entity.dart';
import 'package:consumo/modules/posts/repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts({required this.repository});

  Future<List<PostEntity>> call() async {
    return await repository.getPosts();
  }
}
