import 'dart:io' show Directory, File, Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class PawPointsHelper {
  static Uri createCoordinatesUri(
    double latitude,
    double longitude,
    String? label,
  ) {
    Uri uri;

    if (kIsWeb) {
      uri = Uri.https(
        'www.google.com',
        '/maps/search/',
        {'api': '1', 'query': '$latitude,$longitude'},
      );
    } else if (Platform.isAndroid) {
      var query = '$latitude,$longitude';

      if (label != null) query += '($label)';

      uri = Uri(
        scheme: 'geo',
        host: '0,0',
        queryParameters: {'q': query},
      );
    } else if (Platform.isIOS) {
      var params = {
        'll': '$latitude,$longitude',
        'q': label ?? '$latitude, $longitude',
      };

      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https(
        'www.google.com',
        '/maps/search/',
        {'api': '1', 'query': '$latitude,$longitude'},
      );
    }

    return uri;
  }

  static Future<bool> launchMapApp(
    double latitude,
    double longitude,
    String? label,
  ) {
    return launchUrl(
      createCoordinatesUri(latitude, longitude, label),
      mode: LaunchMode.externalApplication,
    );
  }

  static String generatePointKey() {
    const String _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String _digits = '0123456789';
    final Random _random = Random();

    // En az bir harf ekleyin
    String result = _letters[_random.nextInt(_letters.length)];

    // Geri kalan karakterleri rastgele seçin
    for (int i = 1; i < 4; i++) {
      bool isLetter = _random.nextBool();
      if (isLetter) {
        result += _letters[_random.nextInt(_letters.length)];
      } else {
        result += _digits[_random.nextInt(_digits.length)];
      }
    }

    return result;
  }

  static Future<bool> shouldShowIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    return !hasSeenIntro;
  }

  static Future<void> setHasSeenIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }

  static Future<File> getPawCirclePathFile() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = "$tempPath/paw_circle.png";
    var file = File(filePath);
    if (file.existsSync()) {
      return file;
    } else {
      final byteData = await rootBundle.load('assets/images/paw_circle.png');
      final buffer = byteData.buffer;
      await file.create(recursive: true);
      return file.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
  }
}
