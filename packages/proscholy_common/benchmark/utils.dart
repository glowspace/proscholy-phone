import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:proscholy_common/constants.dart';

const _appsDirectory = String.fromEnvironment('APPS_DIRECTORY', defaultValue: '../../apps');

const _dataPaths = {
  'ZPS': '$_appsDirectory/zps/assets/data.json.gz',
  'EZ': '$_appsDirectory/ez/assets/data.json.gz',
  'EK': '$_appsDirectory/ek/assets/data.json.gz',
};

String get target => isZPS ? 'ZPS' : (isEZ ? 'EZ' : 'EK');

File get appDataFile => File(_dataPaths[target]!);

class Benchmark {
  final String name;
  final results = <Map<String, Object>>[];

  Benchmark(this.name);

  // measures `action` once, use for slow actions, with `blocking` it also measures how long it blocked the isolate
  Future<T> measure<T>(
    String step,
    Future<T> Function() action, {
    bool blocking = false,
    Map<String, Object> info = const {},
  }) async {
    late final T result;
    final stopwatch = Stopwatch()..start();
    final blockedMs = blocking ? await _longestBlock(() async => result = await action()) : null;

    if (!blocking) result = await action();

    stopwatch.stop();
    results.add({'step': step, 'ms': stopwatch.elapsedMicroseconds / 1000, 'blocked_ms': ?blockedMs, ...info});

    return result;
  }

  // measures `action` repeatedly and reports median and maximum, use for fast actions
  Future<void> measureRepeated(
    String step,
    Future<void> Function() action, {
    int runs = 20,
    Future<void> Function()? before,
    bool blocking = false,
    Map<String, Object> info = const {},
  }) async {
    final times = <double>[];
    final blocks = <double>[];

    for (var i = 0; i < runs; i++) {
      await before?.call();

      final stopwatch = Stopwatch()..start();

      await action();

      stopwatch.stop();
      times.add(stopwatch.elapsedMicroseconds / 1000);
    }

    // timer of blocking measurement would slow down the timed runs, so it has its own runs
    for (var i = 0; blocking && i < runs; i++) {
      await before?.call();

      blocks.add(await _longestBlock(action));
    }

    times.sort();
    blocks.sort();
    results.add({
      'step': step,
      'ms': times[times.length ~/ 2],
      'max_ms': times.last,
      if (blocking) 'blocked_ms': blocks[blocks.length ~/ 2],
      'runs': runs,
      ...info,
    });
  }

  // the longest time a 1 ms timer could not run during `action`, frames of the app could not be drawn for so long
  Future<double> _longestBlock(Future<void> Function() action) async {
    final stopwatch = Stopwatch()..start();
    var lastTick = 0;
    var longest = 0;
    final timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      longest = max(longest, stopwatch.elapsedMicroseconds - lastTick);
      lastTick = stopwatch.elapsedMicroseconds;
    });

    await action();

    timer.cancel();

    return max(longest, stopwatch.elapsedMicroseconds - lastTick) / 1000;
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
