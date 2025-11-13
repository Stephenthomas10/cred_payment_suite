class Refund {
  final String id;
  final String txnId;
  final String merchant;
  final double amount;
  final String stage; // initiated | gateway_credited | bank_credited | posted
  final List<String> history;

  Refund({
    required this.id,
    required this.txnId,
    required this.merchant,
    required this.amount,
    required this.stage,
    required this.history,
  });

  factory Refund.fromJson(Map<String, dynamic> j) => Refund(
        id: j['id'],
        txnId: j['txn_id'],
        merchant: j['merchant'],
        amount: (j['amount'] as num).toDouble(),
        stage: j['stage'],
        history: List<String>.from(j['history'] ?? []),
      );
}
