import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bara/features/auth/screens/bookmark/bookmark_screen.dart';

void main() {
  testWidgets('BookmarkScreen renders header, banner, filter chips, and cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BookmarkScreen(),
      ),
    );

    // Verify header title
    expect(find.text('BARA'), findsOneWidget);

    // Verify banner title
    expect(find.text('Materi & Catatan Tersimpan'), findsOneWidget);

    // Verify filter chips exist
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Study Notes'), findsWidgets);
    expect(find.text('Live Chat'), findsWidgets);
    expect(find.text('Materi Kuliah'), findsWidgets);

    // Verify at least one bookmarked card title renders
    expect(
      find.text('Complete Guide to Advanced Graph Algorithms'),
      findsOneWidget,
    );
  });
}

