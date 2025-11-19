import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:serviapp/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton renders label and triggers callback',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Continuar',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Continuar'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(tapped, isTrue);
  });
}
