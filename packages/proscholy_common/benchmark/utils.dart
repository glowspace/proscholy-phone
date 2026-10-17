import 'dart:convert';
import 'dart:io';

import 'package:proscholy_common/constants.dart';

// repos of the apps are next to this repo by default
const _appsDirectory = String.fromEnvironment('APPS_DIRECTORY', defaultValue: '..');

const _dataPaths = {
  'ZPS': '$_appsDirectory/proscholy-flutter/assets/data.json',
  'EZ': '$_appsDirectory/evangelicky-zpevnik-phone/assets/data.json',
  'EK': '$_appsDirectory/evangelicky-kancional-phone/assets/data.json',
};

String get target => isZPS ? 'ZPS' : (isEZ ? 'EZ' : 'EK');

File get appDataFile => File(_dataPaths[target]!);

class Benchmark {
  final String name;
  final results = <Map<String, Object>>[];

  Benchmark(this.name);

  // measures `action` once, use for slow actions
  Future<T> measure<T>(String step, Future<T> Function() action, {Map<String, Object> info = const {}}) async {
    final stopwatch = Stopwatch()..start();
    final result = await action();

    stopwatch.stop();
    results.add({'step': step, 'ms': stopwatch.elapsedMicroseconds / 1000, ...info});

    return result;
  }

  // measures `action` repeatedly and reports median and maximum, use for fast actions
  Future<void> measureRepeated(
    String step,
    Future<void> Function() action, {
    int runs = 20,
    Future<void> Function()? before,
    Map<String, Object> info = const {},
  }) async {
    final times = <double>[];

    for (var i = 0; i < runs; i++) {
      await before?.call();

      final stopwatch = Stopwatch()..start();

      await action();

      stopwatch.stop();
      times.add(stopwatch.elapsedMicroseconds / 1000);
    }

    times.sort();
    results.add({'step': step, 'ms': times[times.length ~/ 2], 'max_ms': times.last, 'runs': runs, ...info});
  }

  // results are printed and saved to `build/benchmarks`, so they can be compared
  void save() {
    if (results.isEmpty) return;

    final json = {'benchmark': name, 'target': target, 'date': DateTime.now().toIso8601String(), 'results': results};
    final file = File('build/benchmarks/$name-$target.json')..createSync(recursive: true);

    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));

    for (final result in results) {
      // ignore: avoid_print
      print(
        '${result['step']}: ${result['ms']} ms ${result.entries.where((entry) => entry.key != 'step' && entry.key != 'ms').map((entry) => '${entry.key}=${entry.value}').join(' ')}',
      );
    }
  }
}
