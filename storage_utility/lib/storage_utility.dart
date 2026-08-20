import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:storage_utility_platform_interface/storage_utility_platform_interface.dart';

StorageUtilityPlatform get _platform => StorageUtilityPlatform.instance;

/// Number of bytes available in storage.
///
/// If [path] is not specified, the application documents directory path will be used.
Future<int> getFreeBytes({String? path}) async {
  final String targetPath =
      path ?? (await getApplicationDocumentsDirectory()).path;
  return _platform.getFreeBytes(path: targetPath);
}

/// The total number of bytes supported by the storage.
///
/// If [path] is not specified, the application documents directory path will be used.
Future<int> getTotalBytes({String? path}) async {
  final String targetPath =
      path ?? (await getApplicationDocumentsDirectory()).path;
  return _platform.getTotalBytes(path: targetPath);
}

/// Returns bytes as a human-readable string
///
/// * 22 B
/// * 444 MB
/// * 66.66 GB
String formatBytes(int bytes, {int divisor = 1024, int decimals = 2}) {
  if (bytes <= 0) return "0 B";
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  var i = min((log(bytes) / log(divisor)).floor(), suffixes.length - 1);
  return '${(bytes / pow(divisor, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}
