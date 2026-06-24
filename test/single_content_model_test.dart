// Regression test for the "lecture sometimes loads as a blank screen" bug.
//
// SingleContentModel.checkPreviousParts is a non-nullable int that used to be
// assigned straight from json['check_previous_parts']. When the API omitted or
// nulled that field, fromJson threw, CourseService.getSingleContent swallowed it
// to null, and the lecture rendered blank. These tests lock in the null-safe parse.

import 'package:flutter_test/flutter_test.dart';
import 'package:webinar/app/models/single_content_model.dart';

void main() {
  test('tolerates a missing check_previous_parts (was a crash -> blank lecture)', () {
    final m = SingleContentModel.fromJson({'id': 1, 'title': 'Lesson'});
    expect(m.checkPreviousParts, 0);
    expect(m.title, 'Lesson');
  });

  test('tolerates an explicit null check_previous_parts', () {
    final m = SingleContentModel.fromJson({'check_previous_parts': null});
    expect(m.checkPreviousParts, 0);
  });

  test('parses check_previous_parts when present as int or string', () {
    expect(SingleContentModel.fromJson({'check_previous_parts': 1}).checkPreviousParts, 1);
    expect(SingleContentModel.fromJson({'check_previous_parts': '1'}).checkPreviousParts, 1);
  });
}
