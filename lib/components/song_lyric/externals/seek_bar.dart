import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: SliderTheme(
            data: theme.sliderTheme.copyWith(overlayShape: SliderComponentShape.noOverlay),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() => _dragValue = value);

                if (widget.onChanged != null) widget.onChanged!(Duration(milliseconds: value.round()));
              },
              onChangeEnd: (value) {
                _dragValue = null;

                if (widget.onChangeEnd != null) widget.onChangeEnd!(Duration(milliseconds: value.round()));
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(_remainingDuration, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }

  String get _remainingDuration {
    final remaining = widget.duration - widget.position;

    final minutes = '${remaining.inMinutes}'.padLeft(2, '0');
    final seconds = '${remaining.inSeconds % 60}'.padLeft(2, '0');

    return '$minutes:$seconds';
  }
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}
