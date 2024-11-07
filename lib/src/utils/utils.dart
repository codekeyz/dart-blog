import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pharaoh/pharaoh_next.dart';
import 'package:shared/shared.dart';

Future<String> getRandomImage(String searchText) async {
  if (isTestMode) return defaultArticleImage;

  String? resultingImageUrl;

  try {
    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=$searchText&per_page=1'),
      headers: {HttpHeaders.authorizationHeader: env<String>('PEXELS_API_KEY', '')},
    ).timeout(const Duration(seconds: 5));
    final result = jsonDecode(response.body) as Map;
    resultingImageUrl = result['photos'][0]['src']['medium'];
  } catch (error, trace) {
    stderr.writeln('An error occurred while getting image for $searchText');
    stderr.writeln('Error $error');
    stderr.writeln('Trace $trace');
  } finally {
    resultingImageUrl ??= defaultArticleImage;
  }

  return resultingImageUrl;
}
