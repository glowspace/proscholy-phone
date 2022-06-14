// Copyright (c) 2019 Silas Sewell

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// source: https://github.com/silas/dart-sqlite-bm25/blob/master/lib/src/matchinfo.dart
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
