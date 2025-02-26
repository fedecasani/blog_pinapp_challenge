import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/post_repository.dart';
import '../blocs/post_bloc.dart';
import 'post_list_screen.dart';
import 'settings_screen.dart';

class BlogScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  const BlogScreen({super.key, required this.isDarkMode, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(PostRepository()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.blue : Colors.blue,
            title: const Text(
              'Blog',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                child: TabBar(
                  indicatorColor: isDarkMode ? Colors.white : Colors.blue[800],
                  labelColor: isDarkMode ? Colors.white : Colors.black,
                  unselectedLabelColor: isDarkMode ? Colors.grey[500] : Colors.grey,
                  indicatorWeight: 3.0,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Settings'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              const PostListScreen(),
              SettingsScreen(
                isDarkMode: isDarkMode,
                onToggleTheme: onToggleTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
