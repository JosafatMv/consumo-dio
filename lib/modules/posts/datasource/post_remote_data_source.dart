import 'package:consumo/kernel/utils/dio_client.dart';

import '../entities/post_entity.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<PostEntity> getPost(int id);
  Future<PostEntity> createPost(PostModel model);
  Future<PostEntity> updatePost(PostModel model);
  Future<void> deletePost(int id);
  Future<List<PostEntity>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient dioClient;

  PostRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<PostEntity> getPost(int id) async {
    try {
      final response = await dioClient.dio.get('/posts/$id');
      return PostModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load post');
    }
  }

  @override
  Future<PostEntity> createPost(PostModel model) async {
    try {
      final response = await dioClient.dio.post('/posts', data: model.toJson());
      return PostModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create post');
    }
  }

  @override
  Future<PostEntity> updatePost(PostModel model) async {
    try {
      final response =
          await dioClient.dio.put('/posts/${model.id}', data: model.toJson());
      return PostModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update post');
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      final response = await dioClient.dio.delete('/posts/$id');
      
    } catch (e) {
      throw Exception('Failed to delete post');
    }
  }

  @override
  Future<List<PostEntity>> getPosts() async {
    try {
      final response = await dioClient.dio.get('/posts');
      return (response.data as List).map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load posts');
    }
  }
}
