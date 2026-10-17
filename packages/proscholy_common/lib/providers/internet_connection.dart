import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/internet_connection.g.dart';

// fails when there is no internet connection
@riverpod
Future<void> internetConnection(Ref ref) => InternetAddress.lookup('youtube.com');
