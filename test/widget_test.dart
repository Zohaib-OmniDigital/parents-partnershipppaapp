import 'package:flutter_test/flutter_test.dart';
import 'package:parents_partnership/main.dart';
import 'package:parents_partnership/home/home_widget.dart';
import 'package:parents_partnership/pending_status/pending_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parents_partnership/career_page/career_page_widget.dart';
import 'package:parents_partnership/authentication/address_history/address_history_widget.dart';
import 'package:parents_partnership/support/support_widget.dart';
import 'package:parents_partnership/verification/connect/connect_widget.dart';

Widget responsiveTestApp(Widget child) => ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, responsiveChild) => MaterialApp(home: responsiveChild),
      child: child,
    );

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    expect(const MyApp(), isA<MyApp>());
  });

  testWidgets('Home screen fits a small phone and remains scrollable',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: HomeWidget()));
    await tester.pumpAndSettle();

    expect(find.text('WELCOME TO THE VILLAGE'), findsOneWidget);
    expect(find.text('Connections'), findsOneWidget);
    expect(find.text('Verification'), findsOneWidget);
    expect(find.text('Resources'), findsOneWidget);
    expect(find.byType(Scrollable), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Pending status fits a compact screen with large text',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: PendingStatusWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verification Pending'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final screen in <String, Widget>{
    'Support': const SupportWidget(),
    'Career': const CareerPageWidget(),
    'Address history': const AddressHistoryWidget(),
    'Location questionnaire': const ConnectWidget(),
  }.entries) {
    testWidgets('${screen.key} has no overflow on a narrow phone',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(responsiveTestApp(screen.value));
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
    });
  }
}
