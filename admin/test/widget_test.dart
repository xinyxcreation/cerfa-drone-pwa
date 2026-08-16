import 'package:flutter_test/flutter_test.dart';

import 'package:admin/main.dart';

void main() {
  testWidgets(
    'CERFA Drone admin application starts',
    (tester) async {
      await tester.pumpWidget(
        const CerfaAdminApp(),
      );

      expect(
        find.text('CERFA Drone'),
        findsOneWidget,
      );
    },
  );
}
