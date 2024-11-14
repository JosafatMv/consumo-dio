
import '../datasource/post_remote_data_source.dart';
import '../entities/post_entity.dart';
import '../models/post_model.dart';

abstract class PostRepository {
  Future<PostEntity> getPost(int id);
  Future<PostEntity> createPost(PostEntity post);
  Future<PostEntity> updatePost(PostEntity post);
  Future<void> deletePost(int id);
  Future<List<PostEntity>> getPosts();
}

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PostEntity> getPost(int id) async {
    return await remoteDataSource.getPost(id);
  }

  @override
  Future<PostEntity> createPost(PostEntity post) async {
    return await remoteDataSource.createPost(post as PostModel);
  }

  @override
  Future<PostEntity> updatePost(PostEntity post) async {
    return await remoteDataSource.updatePost(post as PostModel);
  }

  @override
  Future<void> deletePost(int id) async {
    return await remoteDataSource.deletePost(id);
  }

  @override
  Future<List<PostEntity>> getPosts() async {
    return await remoteDataSource.getPosts();
  }
}