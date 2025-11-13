import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/refund.dart';

class ApiService {
  static const baseUrl = 'http://127.0.0.1:8000'; // chrome/web

  // ---------- Test ----------
  static Future<String> testConnection() async {
    final res = await http.get(Uri.parse('$baseUrl/bills'));
    if (res.statusCode == 200) return res.body;
    throw Exception('Failed with status: ${res.statusCode}');
  }

  // ---------- LIST REFUNDS ----------
  static Future<List<Refund>> listRefunds() async {
    final res = await http.get(Uri.parse('$baseUrl/refunds'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Refund.fromJson(e)).toList();
    }
    throw Exception('listRefunds failed: ${res.statusCode}');
  }

  // ---------- SEED REFUNDS ----------
  static Future<void> seedRefunds() async {
    final res = await http.post(Uri.parse('$baseUrl/refunds/seed'));
    if (res.statusCode != 200) {
      throw Exception('seedRefunds failed: ${res.statusCode}');
    }
  }

  // ---------- ADVANCE ----------
  static Future<String> advanceRefund(String id) async {
    final res = await http.post(Uri.parse('$baseUrl/refunds/$id/advance'));
    if (res.statusCode == 200) return res.body;
    throw Exception('advanceRefund failed: ${res.statusCode}');
  }

  // ---------- ESCALATE ----------
  static Future<String> escalateRefund(String id) async {
    final res = await http.post(Uri.parse('$baseUrl/refunds/$id/escalate'));
    if (res.statusCode == 200) return res.body;
    throw Exception('escalateRefund failed: ${res.statusCode}');
  }

  // ---------- CREATE NEW REFUND ----------
  static Future<Refund> createRefund(
      String txn, String merchant, double amount) async {
    final res = await http.post(
      Uri.parse('$baseUrl/refunds'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'txn_id': txn,
        'merchant': merchant,
        'amount': amount,
        'stage': 'initiated',
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return Refund.fromJson(data);
    }

    throw Exception('createRefund failed: ${res.statusCode}');
  }
}
