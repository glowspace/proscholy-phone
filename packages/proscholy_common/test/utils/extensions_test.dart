import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/utils/extensions.dart';

void main() {
  group('color from hex', () {
    test('valid colors', () {
      expect(HexColor.fromHex('#1a237e'), const Color(0xff1a237e));
      expect(HexColor.fromHex('1A237E'), const Color(0xff1a237e));
      expect(HexColor.fromHex('#801a237e'), const Color(0x801a237e));
    });

    test('missing or invalid colors', () {
      expect(HexColor.fromHex(null), isNull);
      expect(HexColor.fromHex(''), isNull);
      expect(HexColor.fromHex('#abc'), isNull);
      expect(HexColor.fromHex('modrá'), isNull);
    });
  });
}
