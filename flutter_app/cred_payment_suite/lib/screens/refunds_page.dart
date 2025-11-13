import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/refund.dart';
import '../services/api_service.dart';

class RefundsPage extends StatefulWidget {
  const RefundsPage({super.key});

  @override
  State<RefundsPage> createState() => _RefundsPageState();
}

class _RefundsPageState extends State<RefundsPage> {
  late Future<List<Refund>> _future;

  // stage filter: "all" or one of the stages
  String _stageFilter = 'all';
  static const List<String> _filterOptions = [
    'all',
    'initiated',
    'gateway_credited',
    'bank_credited',
    'posted',
  ];

  @override
  void initState() {
    super.initState();
    _future = ApiService.listRefunds();
  }

  Future<void> _reload() async {
    final fut = ApiService.listRefunds();
    if (!mounted) return;
    setState(() {
      _future = fut;
    });
  }

  List<Refund> _applyFilters(List<Refund> all) {
    if (_stageFilter == 'all') return all;
    return all.where((r) => r.stage == _stageFilter).toList();
  }

  Widget _stageChip(String s, {bool active = false}) {
    return Chip(
      label: Text(s.replaceAll('_', ' ')),
      backgroundColor:
          active ? Colors.deepPurple.shade100 : Colors.grey.shade200,
      labelStyle: TextStyle(
        color: active ? Colors.deepPurple.shade900 : Colors.black87,
        fontWeight: active ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _timeline(Refund r) {
    const order = ["initiated", "gateway_credited", "bank_credited", "posted"];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: order
          .map((s) => _stageChip(s, active: r.history.contains(s)))
          .toList(),
    );
  }

  Widget _analyticsHeader(List<Refund> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    final totalAmount = items.fold<double>(0, (sum, r) => sum + r.amount);

    int countStage(String s) => items.where((r) => r.stage == s).length;

    final initiated = countStage("initiated");
    final gateway = countStage("gateway_credited");
    final bank = countStage("bank_credited");
    final posted = countStage("posted");

    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${items.length} refunds · ₹${totalAmount.toStringAsFixed(2)} in transit',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('initiated: $initiated')),
                Chip(label: Text('gateway: $gateway')),
                Chip(label: Text('bank: $bank')),
                Chip(label: Text('posted: $posted')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _openAddRefundDialog() async {
    final txnCtrl = TextEditingController();
    final merchantCtrl = TextEditingController();
    final amtCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Refund"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: txnCtrl,
              decoration: const InputDecoration(labelText: 'Transaction ID'),
            ),
            TextField(
              controller: merchantCtrl,
              decoration: const InputDecoration(labelText: 'Merchant'),
            ),
            TextField(
              controller: amtCtrl,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (ok == true) {
      try {
        await ApiService.createRefund(
          txnCtrl.text.trim(),
          merchantCtrl.text.trim(),
          double.tryParse(amtCtrl.text.trim()) ?? 0.0,
        );
        await _reload();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refund added.')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add refund failed: $e')),
        );
      }
    }
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _filterOptions.map((opt) {
          final selected = _stageFilter == opt;
          final label =
              opt == 'all' ? 'All stages' : opt.replaceAll('_', ' ');
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _stageFilter = opt;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refunds"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: _reload,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildFilterBar(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddRefundDialog,
        label: const Text("Add Refund"),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Refund>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final allItems = snap.data ?? [];
          if (allItems.isEmpty) {
            return const Center(
              child: Text('No refunds yet. Tap Add Refund or seed via API.'),
            );
          }

          final items = _applyFilters(allItems);

          if (items.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _analyticsHeader(allItems),
                ),
                const SizedBox(height: 16),
                const Expanded(
                  child: Center(
                    child: Text('No refunds match this filter.'),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: items.length + 1, // +1 for analytics header
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              if (index == 0) {
                // analytics card uses ALL refunds
                return _analyticsHeader(allItems);
              }

              final r = items[index - 1];
              return Card(
                key: ValueKey(r.id),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${r.merchant} • ₹${r.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Txn: ${r.txnId}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      _timeline(r),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              try {
                                await ApiService.advanceRefund(r.id);
                                await _reload();
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Advance failed: $e'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.fast_forward),
                            label: const Text('Advance'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () async {
                              try {
                                final res =
                                    await ApiService.escalateRefund(r.id);
                                if (!mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Escalation Created'),
                                    content: Text(
                                      const JsonEncoder.withIndent('  ')
                                          .convert(jsonDecode(res)),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Escalate failed: $e'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.warning),
                            label: const Text('Escalate'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
