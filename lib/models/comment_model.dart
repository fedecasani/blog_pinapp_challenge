class Comment {
  final String name;
  final String email;
  final String body;

  Comment({
    required this.name,
    required this.email,
    required this.body,
  });

  // Factory constructor to create a Comment from a Map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      name: map['name'] ?? 'Sin nombre',
      email: map['email'] ?? 'Sin email',
      body: map['body'] ?? 'Sin contenido',
    );
  }
}
