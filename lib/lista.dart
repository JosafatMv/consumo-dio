import 'package:consumo/kernel/utils/dio_client.dart';
import 'package:consumo/modules/posts/datasource/post_remote_data_source.dart';
import 'package:consumo/modules/posts/entities/post_entity.dart';
import 'package:consumo/modules/posts/repositories/post_repository.dart';
import 'package:consumo/modules/posts/use_cases/delete_post.dart';
import 'package:consumo/modules/posts/use_cases/get_posts.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  late Dio dio;
  List<PostEntity> posts = [];

  @override
  void initState() {
    super.initState();
    dio = Dio(); // Inicializar Dio
    fetchPosts(); // Llamar al método para obtener los posts
  }

  // Método para obtener los posts desde el servidor
  Future<void> fetchPosts() async {
    try {
      PostRepository postRepository = PostRepositoryImpl(
        remoteDataSource: PostRemoteDataSourceImpl(
          dioClient: DioClient(baseUrl: 'https://jsonplaceholder.typicode.com'),
        ),
      );

      GetPosts getPosts = GetPosts(repository: postRepository);
      List<PostEntity> fetchedPosts = await getPosts.call();

      setState(() {
        posts =
            fetchedPosts; // Actualiza la lista de posts y redibuja la pantalla
      });
    } catch (e) {
      print("Error al hacer la consulta: $e");
    }
  }

  // Método para eliminar un post
  void deletePost(int id) {
    try {
      PostRepository postRepository = PostRepositoryImpl(
        remoteDataSource: PostRemoteDataSourceImpl(
          dioClient: DioClient(baseUrl: 'https://jsonplaceholder.typicode.com'),
        ),
      );

      DeletePost deletePost = DeletePost(repository: postRepository);
      deletePost.call(id);

      setState(() {
        posts.removeWhere((post) => post.id == id);
      });
    } catch (e) {
      print("Error al hacer la consulta: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Posts'),
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Mientras carga
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                  leading: CircleAvatar(
                    child: Text(post.id.toString()), // Muestra el ID del post
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón de editar
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navegar a la pantalla de registro con los datos del post
                          Navigator.pushNamed(
                            context,
                            '/register',
                            arguments: post, // Pasar los datos del post
                          );
                        },
                      ),
                      // Botón de eliminar
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Eliminar el post directamente
                          deletePost(post.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de registro sin datos
          Navigator.pushNamed(context, '/register');
        },
        child: const Icon(Icons.person_add),
        tooltip: 'Ir a Registro',
      ),
    );
  }
}
