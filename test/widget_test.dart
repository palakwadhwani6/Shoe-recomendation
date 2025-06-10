import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_project/main.dart';
import 'package:first_project/service.dart';


// Assume this method exists in your main.dart or a utility file
Future<bool> isLoggedIn() async {
  // For testing purposes, mock login status
  // In real usage, it might use SharedPreferences or FirebaseAuth
  return Future.value(false);
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Arrange: Fetch login status
    bool loggedIn = await isLoggedIn();

    // Act: Build the app with login status
    await tester.pumpWidget(MyApp(isLoggedIn: loggedIn));

    // Assert: Verify counter starts at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Act: Tap the '+' button to increment counter
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Assert: Counter should now be 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
