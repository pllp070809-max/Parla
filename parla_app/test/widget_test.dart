import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parla_app/screens/salon_detail_screen.dart';
import 'package:parla_app/screens/salon_gallery_screen.dart';
import 'package:parla_app/screens/salon_staff_screen.dart';
import 'package:parla_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpSalonDetail(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildParlaTheme(),
          home: const SalonDetailScreen(salonId: 1),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Finder mainVerticalScroll() {
    return find
        .byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        )
        .first;
  }

  testWidgets('Salon detail renders services and opens booking flow',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);

    expect(find.text('Indi Salonlary'), findsWidgets);
    expect(find.byKey(const ValueKey('section-title-services')), findsOneWidget);
    expect(find.text('Aýal saç kesimi'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Bron et'), findsOneWidget);

    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Bron et'));
    await tester.tap(find.widgetWithText(FilledButton, 'Bron et'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Hyzmat saylaň'), findsOneWidget);
    expect(find.text('Dowam et'), findsOneWidget);
  });

  testWidgets('Sticky section navigator appears after scroll',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();
    final opacityFinder = find.byKey(
      const ValueKey('sticky-section-nav-opacity'),
    );

    expect(find.byKey(const ValueKey('sticky-section-nav')), findsOneWidget);
    expect(
      tester.widget<AnimatedOpacity>(opacityFinder).opacity,
      equals(0),
    );

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('section-title-team')),
      220,
      scrollable: mainScroll,
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<AnimatedOpacity>(opacityFinder).opacity,
      equals(1),
    );
    expect(find.byKey(const ValueKey('sticky-salon-title')), findsOneWidget);
    expect(find.byKey(const ValueKey('sticky-back-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('sticky-share-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('sticky-favorite-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('sticky-tab-indicator-0')), findsOneWidget);
  });

  testWidgets('Sticky tabs jump to sections and review block stays hidden',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('section-title-team')),
      220,
      scrollable: mainScroll,
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const ValueKey('sticky-section-nav-opacity')),
          )
          .opacity,
      equals(1),
    );
    expect(find.text('Synlar'), findsNothing);
    expect(find.text('Review'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('sticky-tab-1')));
    await tester.pumpAndSettle();

    final teamDy =
        tester.getTopLeft(find.byKey(const ValueKey('section-title-team'))).dy;
    expect(teamDy, greaterThan(0));
    expect(teamDy, lessThan(260));
    expect(find.byKey(const ValueKey('sticky-tab-indicator-1')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('sticky-tab-2')));
    await tester.pumpAndSettle();

    final portfolioDy =
        tester.getTopLeft(find.byKey(const ValueKey('section-title-portfolio'))).dy;
    expect(portfolioDy, greaterThan(0));
    expect(portfolioDy, lessThan(260));
    expect(find.byKey(const ValueKey('sticky-tab-indicator-2')), findsOneWidget);
  });

  testWidgets('Team action and portfolio tiles open next screens',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('section-title-team')),
      220,
      scrollable: mainScroll,
    );
    await tester.drag(mainScroll, const Offset(0, 150));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('team-see-all')));
    await tester.pumpAndSettle();

    expect(find.byType(SalonStaffScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('portfolio-tile-0')),
      220,
      scrollable: mainScroll,
    );
    await tester.drag(mainScroll, const Offset(0, 150));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('portfolio-tile-0')));
    await tester.pumpAndSettle();

    expect(find.byType(SalonGalleryScreen), findsOneWidget);
  });
}
