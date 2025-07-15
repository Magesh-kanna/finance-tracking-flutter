class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionModelType type;
  final String category;
  final String merchant;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.merchant,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      type: json['type'] == 'income'
          ? TransactionModelType.income
          : TransactionModelType.expense,
      category: json['category'],
      merchant: json['merchant'],
    );
  }
}

enum TransactionModelType { income, expense }
