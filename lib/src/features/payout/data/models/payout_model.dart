class PayoutModel {
  final int? id;
  final String beneficiaryName;
  final String account;
  final String ifsc;
  final double amount;
  final String date;

  PayoutModel({
    this.id,
    required this.beneficiaryName,
    required this.account,
    required this.ifsc,
    required this.amount,
  }) : date = DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'beneficiaryname': beneficiaryName,
      'account': account,
      'ifsc': ifsc,
      'amount': amount,
      'date': date,
    };
  }

  factory PayoutModel.fromMap(Map<String, dynamic> map) {
    return PayoutModel(
      id: map['id'],
      beneficiaryName: map['beneficiaryname'],
      account: map['account'],
      ifsc: map['ifsc'],
      amount: map['amount'],
    );
  }
}
