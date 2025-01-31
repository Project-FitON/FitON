class Payment {
  final String paymentId;
  final String orderId;
  final double amount;
  final String method;
  final String status;
  final DateTime createdAt;

  Payment({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'] as String,
      orderId: json['order_id'] as String,
      amount: json['amount'] as double,
      method: json['method'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'order_id': orderId,
      'amount': amount,
      'method': method,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
