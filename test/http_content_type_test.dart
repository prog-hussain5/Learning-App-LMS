// Confirms the auth-login root cause: Dart's http body-setter appends "; charset=utf-8"
// to Content-Type when the header is already set. The server's RequestType middleware on
// auth routes rejects anything != exactly 'application/json'. So request order matters:
//   headers-then-body  -> 'application/json; charset=utf-8'  (REJECTED by RequestType)
//   body-then-headers  -> 'application/json'                  (accepted)

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('headers-then-body appends charset (the bug)', () {
    final r = http.Request('POST', Uri.parse('https://x.test/login'));
    r.headers.addAll({'Content-Type': 'application/json'});
    r.body = '{"a":1}';
    expect(r.headers['content-type'], 'application/json; charset=utf-8');
  });

  test('body-then-headers yields exact application/json (the fix)', () {
    final r = http.Request('POST', Uri.parse('https://x.test/login'));
    r.body = '{"a":1}';
    r.headers.addAll({'Content-Type': 'application/json'});
    expect(r.headers['content-type'], 'application/json');
  });
}
