import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/song_lyric/utils/converter.dart';

void main() {
  group('transpose', () {
    test('up', () {
      expect(transpose('C', 2), 'D');
      expect(transpose('Ami', 3), 'Cmi');
      expect(transpose('H7', 1), 'C7');
      expect(transpose('E', 1), 'F');
    });

    test('down', () {
      expect(transpose('C', -1), 'H');
      expect(transpose('C#', -1), 'C');
      expect(transpose('F', -13), 'E');
    });

    test('all chords in chord', () {
      expect(transpose('C/E', 2), 'D/F#');
    });

    test('by octave keeps chord', () {
      expect(transpose('Fsus4', 12), 'Fsus4');
      expect(transpose('G#mi', -12), 'G#mi');
    });
  });

  group('accidentals', () {
    test('to flats', () {
      expect(convertAccidentals('A#', 1), 'B');
      expect(convertAccidentals('C#mi', 1), 'Dbmi');
      expect(convertAccidentals('D#/A#', 1), 'Eb/B');
      expect(convertAccidentals('Ami', 1), 'Ami');
    });

    test('to sharps', () {
      expect(convertAccidentals('B', 0), 'A#');
      expect(convertAccidentals('Es', 0), 'D#');
      expect(convertAccidentals('Ab7', 0), 'G#7');
      expect(convertAccidentals('Hmi', 0), 'Hmi');
    });

    test('sus is not flat', () {
      expect(convertAccidentals('Esus4', 0), 'Esus4');
      expect(convertAccidentals('Asus2', 0), 'Asus2');
    });

    test('transposed and shown with flats', () {
      expect(convertAccidentals(transpose('A', 1), 1), 'B');
      expect(convertAccidentals(transpose('Dmi', 1), 1), 'Ebmi');
    });
  });
}
