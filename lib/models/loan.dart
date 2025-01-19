import 'book.dart';

class Loan {
  final int id;
  final int userId;
  final int bookId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRetrieved;
  final bool isReturned;
  Book? book; // Make it nullable since we'll fetch it separately

  Loan({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.startDate,
    required this.endDate,
    required this.isRetrieved,
    required this.isReturned,
    this.book,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      startDate: DateTime.parse(json['loanStartDate']),
      endDate: DateTime.parse(json['loanEndDate']),
      isRetrieved: json['retrieved'],
      isReturned: json['returned'],
    );
  }
}
