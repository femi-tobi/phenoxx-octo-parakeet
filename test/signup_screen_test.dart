import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phenoxx/signup_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  testWidgets('Signup screen structure test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Wrap in MaterialApp to provide Theme and Navigator
    await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

    // Verify Title
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Phenoxx'), findsOneWidget);

    // Verify Fields (Labels)
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);

    // Verify TextFields exist
    expect(find.byType(TextField), findsNWidgets(4));

    // Verify Checkbox
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.textContaining('Terms of Service'), findsOneWidget);

    // Verify Button
    expect(find.text('Create Account'), findsOneWidget);

    // Verify Social Buttons
    expect(find.byIcon(FontAwesomeIcons.github), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.google), findsOneWidget);
  });
}
