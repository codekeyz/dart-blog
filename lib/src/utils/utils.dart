import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:pharaoh/pharaoh_next.dart';
import 'package:shared/shared.dart';

Future<String?> getRandomImage(String searchText) async {
  if (isTestMode) {
    return 'https://dart.dev/assets/shared/dart-logo-for-shares.png';
  }

  try {
    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=$searchText&per_page=1'),
      headers: {HttpHeaders.authorizationHeader: env<String>('PEXELS_API_KEY', '')},
    ).timeout(const Duration(seconds: 2));
    final result = await Isolate.run(() => jsonDecode(response.body)) as Map;
    return result['photos'][0]['src']['medium'];
  } catch (_) {}
  return null;
}
