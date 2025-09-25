import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:proscholy_common/models/presentation.dart';

class PresentationService {
  final methodChannel = const MethodChannel('proscholyCommon/presentation');
  final streamChannel = const EventChannel('proscholyCommon/presentation/stream');

  const PresentationService._();

  static PresentationService instance = const PresentationService._();

  Future<void> startPresentation() => methodChannel.invokeMethod('startPresentation');

  Future<void> stopPresentation() => methodChannel.invokeMethod('stopPresentation');

  Future<bool> isExternalScreenConnected() =>
      methodChannel.invokeMethod<bool>('isExternalScreenConnected').then((value) => value ?? false);

  Future<void> transferData(PresentationData data) => methodChannel.invokeMethod('transferData', jsonEncode(data));

  Stream<PresentationData> getDataStream() =>
      streamChannel.receiveBroadcastStream().map((event) => PresentationData.fromJson(jsonDecode(event)));
}
