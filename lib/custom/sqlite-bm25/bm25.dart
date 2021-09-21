// source: https://github.com/silas/dart-sqlite-bm25/blob/master/lib/src/bm25.dart
// Update for null-safety features.

import 'dart:math' show log;
import 'dart:typed_data' show Uint8List;

import 'package:zpevnik/custom/sqlite-bm25/match_info.dart';

const _pIndex = 0;
const _cIndex = 1;
const _nIndex = 2;
const _aIndex = 3;

/// The format string that should be used with matchinfo() on an FTS4
/// virtual table.
const bm25FormatString = 'pcnalx';

/// Converts matchinfo() data to a relevance score (lower is more
/// relavent).
double bm25(Uint8List matchinfo, {double k1 = 1.2, double b = 0.75, List<double>? weights}) {
  final data = Matchinfo.decode(matchinfo);

  final termCount = data[_pIndex];
  final columnCount = data[_cIndex];
  final rowCount = data[_nIndex];

  final lIndex = _aIndex + columnCount;
  final xIndex = lIndex + columnCount;

  final weightsLength = weights?.length ?? 0;
  double score = 0;

  for (var c = 0; c < columnCount; c++) {
    final weight = c < weightsLength ? weights![c] : 1;
    if (weight == 0) continue;

    int avgLength = data[_aIndex + c];
    if (avgLength == 0) avgLength = 1;

    final columnLength = data[lIndex + c];

    for (var t = 0; t < termCount; t++) {
      final x = xIndex + (3 * (c + t * columnCount));
      final termCount = data[x];
      final rowsWithTermCount = data[x + 2];

      double idf = log((rowCount - rowsWithTermCount + 0.5) / (rowsWithTermCount + 0.5));
      if (idf <= 0) idf = 0.000001;

      score += idf * ((termCount * (k1 + 1)) / (termCount + k1 * (1 - b + b * columnLength / avgLength))) * weight;
    }
  }

  return -score;
}
