import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_strength_meter_library/flutter_password_strength_meter_library.dart';

void main() {
  testWidgets('PasswordStrengthField renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PasswordStrengthField(
            labelText: 'Password',
            hintText: 'Enter your password',
          ),
        ),
      ),
    );

    expect(find.byType(PasswordStrengthField), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
