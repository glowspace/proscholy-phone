// source: https://github.com/silas/dart-sqlite-bm25/blob/master/lib/src/match_info.dart
// Update for null-safety features.

import 'dart:typed_data';

class Matchinfo {
  static Uint32List decode(Uint8List encoded) {
    final byteData = ByteData.view(encoded.buffer, encoded.offsetInBytes, encoded.lengthInBytes);

    if (byteData.lengthInBytes % 4 != 0) {
      throw ArgumentError('Must be divisible by 4: ${byteData.lengthInBytes}');
    }

    final length = byteData.lengthInBytes ~/ 4;
    final decoded = Uint32List(length);
    for (var i = 0; i < length; i++) {
      decoded[i] = byteData.getUint32(i * 4, Endian.host);
    }

    return decoded;
  }
}
