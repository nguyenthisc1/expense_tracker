import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/main.dart';

void main() {
  group('MoneyFlowApp', () {
    testWidgets('should render without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MoneyFlowApp());
      expect(find.byType(MoneyFlowApp), findsOneWidget);
    });
  });
}
