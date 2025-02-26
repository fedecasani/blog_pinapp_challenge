import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/post_repository.dart';
import '../blocs/post_bloc.dart';
import 'post_list_screen.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(PostRepository()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Blog'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Posts'),
                Tab(text: 'Settings'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              PostListScreen(),
              Center(child: Text('Settings content here.')),
            ],
          ),
        ),
      ),
    );
  }
}