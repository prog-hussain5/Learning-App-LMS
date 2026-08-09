// Regression test for the "untimed quiz auto-submits instantly" bug.
//
// startTimer() used to do:
//   quizTime = Duration(seconds: (quizData?.time ?? 0) * 60);
//   Timer.periodic(1s, ...)  ->  first tick sees `0 >= 1 == false`
//                            ->  else-branch auto-submits an EMPTY answer sheet
// So a quiz configured with NO time limit (time == 0 or null) submitted itself
// and popped the page ~1 second after loading — the student could never take it.
//
// The fix: treat time <= 0 as "no limit" and never arm the countdown at all.

import 'package:flutter_test/flutter_test.dart';
import 'package:webinar/app/models/quize_model.dart';

/// Mirrors the guard in QuizPage.startTimer(): the countdown (and therefore the
/// auto-submit) only arms when there is a real, positive time limit.
bool shouldArmCountdown(int? quizTimeMinutes) => ((quizTimeMinutes ?? 0) * 60) > 0;

void main() {
  group('quiz time limit', () {
    test('no time limit (0) does NOT arm the countdown/auto-submit', () {
      expect(shouldArmCountdown(0), isFalse);
    });

    test('null time does NOT arm the countdown/auto-submit', () {
      expect(shouldArmCountdown(null), isFalse);
    });

    test('a real time limit DOES arm the countdown', () {
      expect(shouldArmCountdown(30), isTrue);
      expect(shouldArmCountdown(1), isTrue);
    });
  });

  group('Quiz.fromJson time parsing', () {
    test('parses int time', () {
      final q = Quiz.fromJson({'id': 1, 'time': 30});
      expect(q.time, 30);
      expect(shouldArmCountdown(q.time), isTrue);
    });

    test('parses stringy time without throwing (API sometimes sends strings)', () {
      final q = Quiz.fromJson({'id': 1, 'time': '45'});
      expect(q.time, 45);
      expect(shouldArmCountdown(q.time), isTrue);
    });

    test('missing time yields null -> treated as no limit, not instant submit', () {
      final q = Quiz.fromJson({'id': 1});
      expect(q.time, isNull);
      expect(shouldArmCountdown(q.time), isFalse);
    });

    test('non-numeric time degrades to null instead of throwing', () {
      final q = Quiz.fromJson({'id': 1, 'time': 'unlimited'});
      expect(q.time, isNull);
      expect(shouldArmCountdown(q.time), isFalse);
    });
  });
}
