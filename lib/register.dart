import 'package:consumo/kernel/utils/dio_client.dart';
import 'package:consumo/modules/posts/datasource/post_remote_data_source.dart';
import 'package:consumo/modules/posts/entities/post_entity.dart';
import 'package:consumo/modules/posts/models/post_model.dart';
import 'package:consumo/modules/posts/repositories/post_repository.dart';
import 'package:consumo/modules/posts/use_cases/create_post.dart';
import 'package:consumo/modules/posts/use_cases/update_post.dart';
import 'package:flutter/material.dart';
import 'lista.dart'; // Importa la clase Post para acceder al modelo

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userId = TextEditingController();
  final TextEditingController _body = TextEditingController();
  final TextEditingController _title = TextEditingController();
  PostEntity? _post; // Para almacenar el post que estamos editando

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recibir el post a editar, si lo hay
    final PostEntity? post =
        ModalRoute.of(context)?.settings.arguments as PostEntity?;
    if (post != null) {
      _post = post;
      // Cargar los datos del post en los controladores
      _userId.text = post.userId.toString();
      _title.text = post.title;
      _body.text = post.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_post == null ? 'Registrar Post' : 'Editar Post'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo User ID
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "0",
                          label: Text("User ID"),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _userId,
                        readOnly: _post != null, // No editable si es edición
                      ),
                      const SizedBox(height: 16.0),
                      // Campo Título
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Titulo",
                          label: Text("Título"),
                          prefixIcon: Icon(Icons.title),
                        ),
                        controller: _title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese un título';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Campo Cuerpo del post
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Escribe la publicación",
                          label: Text("Publicación"),
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        controller: _body,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el cuerpo del post';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32.0),
                      // Botón de guardar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _savePost,
                          child: Text(
                              _post == null ? 'Crear Post' : 'Guardar Cambios'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para guardar los cambios del post
  void _savePost() async {
    if (_post != null) {
      // Si estamos editando, actualizar el post
      try {
        PostRepository postRepository = PostRepositoryImpl(
          remoteDataSource: PostRemoteDataSourceImpl(
            dioClient:
                DioClient(baseUrl: 'https://jsonplaceholder.typicode.com'),
          ),
        );

        UpdatePost updatePost = UpdatePost(repository: postRepository);
        PostEntity post = PostModel(
          id: _post!.id,
          userId: int.parse(_userId.text),
          title: _title.text,
          body: _body.text,
        );

        await updatePost.execute(post);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Lista(),
          ),
        );
      } catch (e) {
        print("Error al hacer la consulta: $e");
      }

      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      try {
        PostRepository postRepository = PostRepositoryImpl(
          remoteDataSource: PostRemoteDataSourceImpl(
            dioClient:
                DioClient(baseUrl: 'https://jsonplaceholder.typicode.com'),
          ),
        );

        CreatePost createPost = CreatePost(repository: postRepository);
        PostEntity post = PostModel(
          id: 0,
          userId: int.parse(_userId.text),
          title: _title.text,
          body: _body.text,
        );

        await createPost.call(post);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Lista(),
          ),
        );
      } catch (e) {
        print("Error al hacer la consulta: $e");
      }
    }
  }
}
