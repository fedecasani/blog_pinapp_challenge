import 'package:blog_pinapp_challenge/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final String postType;
  final Color postColor;
  final String imageUrl;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.postType,
    required this.postColor,
    required this.imageUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  static const platform = MethodChannel('commentsChannel');

  Future<List<Comment>> _fetchComments() async {
    try {
      final List<dynamic> result = await platform.invokeMethod(
        'getComments',
        {'postId': widget.post.id},
      );

      return result.map<Comment>((comment) {
        if (comment is Map) {
          return Comment.fromMap(comment.cast<String, dynamic>());
        }
        return Comment(
          name: 'Comentario inválido',
          email: '',
          body: '',
        );
      }).toList();
    } on PlatformException catch (e) {
      return [
        Comment(
          name: 'Error',
          email: '',
          body: 'Error al obtener comentarios: ${e.message}',
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostCategory(),
              const SizedBox(height: 16),
              _buildImage(),
              const SizedBox(height: 16),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildBody(),
              const SizedBox(height: 16),
              _buildCommentsSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: widget.postColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.postType,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        widget.imageUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/default_image.png',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      _capitalizeFirstLetter(widget.post.title),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBody() {
    return Text(
      _capitalizeFirstLetter(widget.post.body),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comentarios:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<Comment>>(
          future: _fetchComments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return const Text("Error al cargar los comentarios.");
            }
            final comments = snapshot.data!;
            if (comments.isEmpty) {
              return const Text("No hay comentarios.");
            }
            return SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    comment.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.email, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    comment.email,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              comment.body,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
