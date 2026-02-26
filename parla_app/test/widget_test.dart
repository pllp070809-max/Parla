import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parla_app/main.dart';

void main() {
  testWidgets('App renders bottom nav', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ParlaApp()));
    expect(find.text('Sahypa'), findsOneWidget);
    expect(find.text('Bronlarym'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
