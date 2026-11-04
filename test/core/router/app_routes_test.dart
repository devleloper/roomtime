import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/core/router/app_routes.dart';

void main() {
  group('AppRoutes.roomRedirect', () {
    late PendingHomeNotice notices;

    setUp(() => notices = PendingHomeNotice());

    test('a canonical code stays, no notice', () {
      expect(AppRoutes.roomRedirect('abcdefghjk', notices), isNull);
      expect(notices.take(), isNull);
    });

    test('another spelling goes to the canonical path, no notice', () {
      expect(AppRoutes.roomRedirect('ABC-DEFG-HJK', notices), '/r/abcdefghjk');
      expect(notices.take(), isNull);
    });

    for (final raw in ['zz', '', 'abcdefghj', 'abcdefghjk1', '%FF']) {
      test('"$raw" goes Home with a one-shot invalid-link notice', () {
        expect(AppRoutes.roomRedirect(raw, notices), AppRoutes.home);
        expect(notices.take(), HomeNotice.invalidInviteLink);
        expect(notices.take(), isNull);
      });
    }
  });
}
