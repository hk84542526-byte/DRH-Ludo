import 'package:flutter_test/flutter_test.dart';

import 'package:drh_ludo/main.dart';

void main() {
  testWidgets('DRH LUDO app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const DrhLudoApp());
    // Splash screen contains the tagline
    expect(find.textContaining('चैंपियन'), findsOneWidget);
  });
}
