import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';
import '../models/post_model.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc(this.repository) : super(PostInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(
      FetchPostsEvent event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());

      // Intentar obtener los posts desde el repositorio
      final posts = await repository.fetchPosts(event.start, event.limit);

      // Almacenar los posts en caché
      await _cachePosts(posts);

      // Emitir estado con los posts cargados
      emit(PostLoaded(posts));
    } catch (e) {
      // Si falla la carga, intentar obtener los posts en caché
      final cachedPosts = await _getCachedPosts(event.start, event.limit);
      if (cachedPosts.isNotEmpty) {
        emit(PostLoaded(cachedPosts));
      } else {
        emit(PostError(e.toString()));
      }
    }
  }

  // Método para almacenar los posts en caché usando SharedPreferences
  Future<void> _cachePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => post.toJson()).toList();
    await prefs.setString('cached_posts', json.encode(postsJson));
  }

  // Método para obtener los posts en caché desde SharedPreferences
  Future<List<Post>> _getCachedPosts(int start, int limit) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_posts');

    if (cachedData != null) {
      final List<dynamic> data = List<dynamic>.from(json.decode(cachedData));

      return data
          .skip(start)
          .take(limit)
          .map((json) => Post.fromJson(json))
          .toList();
    }
    return [];
  }
}
