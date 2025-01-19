class Book {
  final int id;
  final String title;
  final String author;
  final String isbn;
  final String coverUrl;
  final int publishedYear;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.coverUrl,
    required this.publishedYear,
    required this.isAvailable,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      coverUrl: json['coverUrl'],
      publishedYear: json['publishedYear'],
      isAvailable: json['available'],
    );
  }
}
