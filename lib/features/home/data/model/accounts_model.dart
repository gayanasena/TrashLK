class Account {
  final double currentBalance;
  final double earnings;
  final double dueAmount;
  final String notes;

  Account({
    required this.currentBalance,
    required this.earnings,
    required this.dueAmount,
    required this.notes,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      currentBalance: json['currentBalance']?.toDouble() ?? 0.0,
      earnings: json['earnings']?.toDouble() ?? 0.0,
      dueAmount: json['dueAmount']?.toDouble() ?? 0.0,
      notes: json['notes'] ?? '',
    );
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      currentBalance: map['currentBalance']?.toDouble() ?? 0.0,
      earnings: map['earnings']?.toDouble() ?? 0.0,
      dueAmount: map['dueAmount']?.toDouble() ?? 0.0,
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentBalance': currentBalance,
      'earnings': earnings,
      'dueAmount': dueAmount,
      'notes': notes,
    };
  }
}
