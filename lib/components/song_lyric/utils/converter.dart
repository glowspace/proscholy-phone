final _plainChords = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'H'];
final _plainChordsRE = RegExp(r'[CDEFGAH]#?');

final _toFlat = {'C#': 'Db', 'D#': 'Eb', 'F#': 'Gb', 'G#': 'Ab', 'A#': 'B'};
final _toFlatRE = RegExp(r'[CDEFGAH]#');

final _fromFlat = {
  'Db': 'C#',
  'Eb': 'D#',
  'Gb': 'F#',
  'Ab': 'G#',
  'B': 'A#',
  'Ds': 'C#',
  'Es': 'D#',
  'Gs': 'F#',
  'As': 'G#',
  'S': 'A#',
};
final _fromFlatRE = RegExp(r'([CDEFGAH][bs](?!us)|B)');

String transpose(String chord, int transposition) {
  return chord.replaceAllMapped(_plainChordsRE, (match) {
    final transposedIndex =
        (_plainChords.indexOf(chord.substring(match.start, match.end)) + transposition) % _plainChords.length;

    return _plainChords[transposedIndex];
  });
}

String convertAccidentals(String chord, int accidental) {
  return chord.replaceAllMapped(accidental == 1 ? _toFlatRE : _fromFlatRE, (match) {
    return accidental == 1
        ? (_toFlat[chord.substring(match.start, match.end)] ?? '')
        : (_fromFlat[chord.substring(match.start, match.end)] ?? '');
  });
}
