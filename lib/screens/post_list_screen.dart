import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc.dart';
import '../blocs/post_event.dart';
import '../blocs/post_state.dart';
import '../widgets/post_card.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _start = 0;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostBloc>().add(FetchPostsEvent(start: _start, limit: _limit));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _start += _limit;
      context
          .read<PostBloc>()
          .add(FetchPostsEvent(start: _start, limit: _limit));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading && _start == 0) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: state.posts[index]);
            },
          );
        } else if (state is PostError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No posts found.'));
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}