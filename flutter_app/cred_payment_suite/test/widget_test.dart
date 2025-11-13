import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cred_payment_suite/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CredPaymentSuiteApp());

    // Basic sanity check: ensure RefundsPage loads.
    expect(find.text('Refunds'), findsOneWidget);
  });
}
