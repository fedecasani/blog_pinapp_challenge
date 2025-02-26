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

  final List<String> postTypes = [
    'Community',
    'Technology',
    'Travel',
    'Lifestyle',
    'News'
  ];
  final List<Color> postColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

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

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 3,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List.generate(postTypes.length, (index) {
                return _buildFilterOption(postTypes[index], postColors[index]);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String filter, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: color,
            ),
            const SizedBox(width: 10),
            Text(
              filter,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading && _start == 0) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    PostCard(post: state.posts[index]),
                  ],
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No posts found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showFilterMenu,
        child: const Icon(Icons.filter_list,
        color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}