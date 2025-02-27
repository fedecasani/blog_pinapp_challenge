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
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  static const platform = MethodChannel('commentsChannel');
  List<String> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final List<dynamic> result = await platform
          .invokeMethod('getComments', {'postId': widget.post.id});
      setState(() {
        comments = result.cast<String>();
        isLoading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        comments = ['Error al obtener comentarios: ${e.message}'];
        isLoading = false;
      });
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
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
              ),
              const SizedBox(height: 16),
              ClipRRect(
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
              ),
              const SizedBox(height: 16),
              Text(
                _capitalizeFirstLetter(widget.post.title),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _capitalizeFirstLetter(widget.post.body),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                "Comentarios:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: comments
                          .map((comment) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text("- $comment"),
                              ))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
