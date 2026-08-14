import 'package:flutter_test/flutter_test.dart';

import 'package:emp_app/app.dart';

void main() {
  testWidgets('PulseHR starts on the branded splash screen', (tester) async {
    await tester.pumpWidget(const PulseHrApp());
    expect(find.text('PulseHR Mobile'), findsOneWidget);
  });
}
