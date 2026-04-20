import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> pumpSalonDetail(
    WidgetTester tester, {
    Future<void> Function(BuildContext context, String text)? shareLauncher,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildParlaTheme(),
          home: SalonDetailScreen(salonId: 1, shareLauncher: shareLauncher),
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

  double stickyHeaderSurfaceOpacity(WidgetTester tester) {
    return tester
        .widget<Opacity>(
            find.byKey(const ValueKey('sticky-header-surface-opacity')))
        .opacity;
  }

  double stickyTabSurfaceOpacity(WidgetTester tester) {
    return tester
        .widget<Opacity>(
            find.byKey(const ValueKey('sticky-tab-surface-opacity')))
        .opacity;
  }

  double stickyNavOpacity(WidgetTester tester) {
    final headerOpacity = stickyHeaderSurfaceOpacity(tester);
    final tabOpacity = stickyTabSurfaceOpacity(tester);
    return headerOpacity > tabOpacity ? headerOpacity : tabOpacity;
  }

  double stickyTopRowOpacity(WidgetTester tester) {
    return tester
        .widget<Opacity>(find.byKey(const ValueKey('sticky-top-row-opacity')))
        .opacity;
  }

  double stickyTabRowOpacity(WidgetTester tester) {
    return tester
        .widget<Opacity>(find.byKey(const ValueKey('sticky-tab-row-opacity')))
        .opacity;
  }

  Icon favouriteButtonIcon(WidgetTester tester) {
    return tester.widget<Icon>(
      find.descendant(
        of: find.byKey(const ValueKey('unified-favorite-button')),
        matching: find.byType(Icon),
      ),
    );
  }

  testWidgets('Salon detail renders services and opens booking flow',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();
    final serviceBookButton = find.widgetWithText(OutlinedButton, 'Bron').first;

    expect(find.text('Indi Salonlary'), findsWidgets);
    expect(
        find.byKey(const ValueKey('section-title-services')), findsOneWidget);
    expect(find.text('AР“Р…al saР“В§ kesimi'), findsOneWidget);
    expect(serviceBookButton, findsOneWidget);

    await tester.scrollUntilVisible(serviceBookButton, 160,
        scrollable: mainScroll);
    await tester.drag(mainScroll, const Offset(0, 120));
    await tester.pumpAndSettle();
    await tester.tap(serviceBookButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Hyzmat saylaР•в‚¬'), findsOneWidget);
    expect(find.text('Dowam et'), findsOneWidget);
  });

  testWidgets('Bottom booking bar shows only service count',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);

    expect(
      find.byKey(const ValueKey('bottom-book-bar-service-count')),
      findsOneWidget,
    );
    expect(find.text('27 hyzmat elР“Р…eter'), findsOneWidget);
    expect(find.textContaining('TMT-dan'), findsNothing);
  });
  testWidgets('Services view-all button toggles expanded list',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('services-view-all-button')),
      120,
      scrollable: mainScroll,
    );
    await tester.pumpAndSettle();

    final collapsedBronButtons =
        find.widgetWithText(OutlinedButton, 'Bron').evaluate().length;
    expect(
      find.byKey(const ValueKey('services-view-all-label-collapsed')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('services-view-all-button')));
    await tester.pump();
    expect(find.byKey(const ValueKey('services-view-all-label-expanded')),
        findsOneWidget);
    await tester.pumpAndSettle();

    final expandedBronButtons =
        find.widgetWithText(OutlinedButton, 'Bron').evaluate().length;
    expect(expandedBronButtons, greaterThan(collapsedBronButtons));
    expect(
      find.byKey(const ValueKey('services-view-all-label-expanded')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('services-view-all-button')));
    await tester.pump();
    expect(find.byKey(const ValueKey('services-view-all-label-collapsed')),
        findsOneWidget);
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(OutlinedButton, 'Bron').evaluate().length,
      equals(collapsedBronButtons),
    );
    expect(
      find.byKey(const ValueKey('services-view-all-label-collapsed')),
      findsOneWidget,
    );
  });


  testWidgets('Sticky section navigator appears after scroll',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    expect(find.byKey(const ValueKey('sticky-section-nav')), findsOneWidget);
    expect(stickyHeaderSurfaceOpacity(tester), equals(0));
    expect(stickyTopRowOpacity(tester), equals(0));
    expect(stickyTabSurfaceOpacity(tester), equals(0));
    expect(stickyTabRowOpacity(tester), equals(0));

    await tester.drag(mainScroll, const Offset(0, -20));
    await tester.pump();

    expect(stickyHeaderSurfaceOpacity(tester), greaterThan(0));
    expect(stickyTopRowOpacity(tester), greaterThan(0));
    expect(stickyTopRowOpacity(tester), lessThan(1));
    expect(stickyTabSurfaceOpacity(tester), equals(0));
    expect(stickyTabRowOpacity(tester), equals(0));

    await tester.drag(mainScroll, const Offset(0, -28));
    await tester.pump();

    expect(stickyHeaderSurfaceOpacity(tester), greaterThan(0.99));
    expect(stickyTopRowOpacity(tester), greaterThan(0.99));
    expect(stickyTabSurfaceOpacity(tester), greaterThan(0));
    expect(stickyTabSurfaceOpacity(tester), lessThan(1));
    expect(stickyTabRowOpacity(tester), greaterThan(0));
    expect(stickyTabRowOpacity(tester), lessThan(1));

    await tester.drag(mainScroll, const Offset(0, 60));
    await tester.pumpAndSettle();

    expect(stickyHeaderSurfaceOpacity(tester), equals(0));
    expect(stickyTopRowOpacity(tester), equals(0));
    expect(stickyTabSurfaceOpacity(tester), equals(0));
    expect(stickyTabRowOpacity(tester), equals(0));
  });

  testWidgets(
      'Sticky section navigator becomes fully visible after deeper scroll',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('section-title-team')),
      220,
      scrollable: mainScroll,
    );
    await tester.pumpAndSettle();

    expect(stickyNavOpacity(tester), equals(1));
    expect(stickyHeaderSurfaceOpacity(tester), equals(1));
    expect(stickyTopRowOpacity(tester), equals(1));
    expect(stickyTabSurfaceOpacity(tester), equals(1));
    expect(stickyTabRowOpacity(tester), equals(1));
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('sticky-section-nav'))).dy,
      equals(0),
    );
    expect(find.byKey(const ValueKey('sticky-salon-title')), findsOneWidget);
    expect(find.byKey(const ValueKey('unified-back-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('unified-share-button')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('unified-favorite-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('sticky-tabs-scroll')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('sticky-tab-indicator-0')), findsOneWidget);
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

    expect(stickyNavOpacity(tester), equals(1));
    expect(find.text('Synlar'), findsNothing);
    expect(find.text('Review'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('sticky-tab-1')));
    await tester.pumpAndSettle();

    final teamDy =
        tester.getTopLeft(find.byKey(const ValueKey('section-title-team'))).dy;
    expect(teamDy, greaterThan(0));
    expect(teamDy, lessThan(260));
    expect(
        find.byKey(const ValueKey('sticky-tab-indicator-1')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('sticky-tab-2')));
    await tester.pumpAndSettle();

    final portfolioDy = tester
        .getTopLeft(find.byKey(const ValueKey('section-title-portfolio')))
        .dy;
    expect(portfolioDy, greaterThan(0));
    expect(portfolioDy, lessThan(260));
    expect(
        find.byKey(const ValueKey('sticky-tab-indicator-2')), findsOneWidget);
  });

  testWidgets('Latest sticky tab tap wins during overlapping scroll animations',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('section-title-team')),
      220,
      scrollable: mainScroll,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('sticky-tab-2')));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tap(find.byKey(const ValueKey('sticky-tab-3')));
    await tester.pump(const Duration(milliseconds: 360));

    expect(
        find.byKey(const ValueKey('sticky-tab-indicator-3')), findsOneWidget);

    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey('sticky-tab-indicator-3')), findsOneWidget);
  });

  testWidgets('Sticky nav keeps latest tab after rapid drag and taps',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('section-title-team')),
      220,
      scrollable: mainScroll,
    );
    await tester.pumpAndSettle();

    await tester.drag(mainScroll, const Offset(0, -80));
    await tester.pump();
    await tester.drag(mainScroll, const Offset(0, 35));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('sticky-tab-2')));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tap(find.byKey(const ValueKey('sticky-tab-3')));
    await tester.pump(const Duration(milliseconds: 360));

    expect(stickyNavOpacity(tester), equals(1));
    expect(
        find.byKey(const ValueKey('sticky-tab-indicator-3')), findsOneWidget);
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

  testWidgets('Hero image tap opens gallery at current image',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);

    await tester.drag(
      find.byKey(const ValueKey('hero-image-tap-target')),
      const Offset(-400, 0),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('hero-image-tap-target')));
    await tester.pumpAndSettle();

    expect(find.byType(SalonGalleryScreen), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && (widget.data?.startsWith('2 / ') ?? false),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Favorite button toggles and persists across rebuilds',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);

    expect(favouriteButtonIcon(tester).icon, Icons.favorite_border_rounded);

    await tester.tap(find.byKey(const ValueKey('unified-favorite-button')));
    await tester.pumpAndSettle();

    expect(favouriteButtonIcon(tester).icon, Icons.favorite_rounded);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('favourite_salon_ids'), contains('1'));

    await pumpSalonDetail(tester);

    expect(favouriteButtonIcon(tester).icon, Icons.favorite_rounded);
  });

  testWidgets('Share button falls back to clipboard when share fails',
      (WidgetTester tester) async {
    Future<void> failingShare(BuildContext context, String text) async {
      throw Exception('share failed');
    }

    await pumpSalonDetail(tester, shareLauncher: failingShare);

    await tester.tap(find.byKey(const ValueKey('unified-share-button')));
    await tester.pumpAndSettle();

    final clipboardData = await Clipboard.getData('text/plain');
    expect(clipboardData?.text, contains('Indi Salonlary'));
    expect(find.text('Salon maglumatlary gР“В¶Р“В§Р“Сrildi'), findsOneWidget);
  });

  testWidgets('About section expands and keeps detail rows visible',
      (WidgetTester tester) async {
    await pumpSalonDetail(tester);
    final mainScroll = mainVerticalScroll();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('section-title-about')),
      220,
      scrollable: mainScroll,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('about-opening-hours-title')),
        findsOneWidget);
    expect(find.byKey(const ValueKey('about-additional-info-title')),
        findsOneWidget);

    final descriptionFinder = find.byKey(const ValueKey('about-description'));
    expect(tester.widget<Text>(descriptionFinder).maxLines, equals(3));

    await tester.tap(find.byKey(const ValueKey('about-toggle-button')));
    await tester.pumpAndSettle();

    expect(tester.widget<Text>(descriptionFinder).maxLines, isNull);
    expect(find.byKey(const ValueKey('about-opening-hours-title')),
        findsOneWidget);
    expect(find.byKey(const ValueKey('about-additional-info-title')),
        findsOneWidget);
  });
}
