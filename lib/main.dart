import 'package:flutter/material.dart';
import 'screens/blog_screen.dart';

void main() {
  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BlogScreen(),
    );
  }
}