import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../user_identity.dart';

class QuestionFormatException implements Exception {
  QuestionFormatException(this.message);
  final String message;

  @override
  String toString() => 'QuestionFormatException: $message';
}

Future<String> formatQuestion({
  required String question,
  required String locale,
}) async {
  final uri = buildApiUri('api/questions/format');
  final userId = await UserIdentity.obtain();
  final headers = await buildAuthenticatedHeaders(
    locale: locale,
    userId: userId,
    additional: const {
      'content-type': 'application/json',
      'accept': 'application/json',
    },
  );

  final body = jsonEncode(<String, String>{
    'question': question,
    'locale': locale,
  });

  http.Response response;
  try {
    response = await http
        .post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 6));
  } on Exception catch (error) {
    throw QuestionFormatException('Network error: $error');
  }

  if (response.statusCode != 200) {
    throw QuestionFormatException(
      'Format request failed (${response.statusCode}): ${response.body}',
    );
  }

  final Map<String, dynamic> payload =
      jsonDecode(response.body) as Map<String, dynamic>;
  if (payload['success'] != true) {
    final error = payload['error'];
    throw QuestionFormatException(
      'Format request failed: ${error ?? payload}',
    );
  }

  final data = payload['data'] as Map<String, dynamic>;
  final formatted = (data['formattedQuestion'] as String?)?.trim();

  if (formatted == null || formatted.isEmpty) {
    throw QuestionFormatException('Empty formatted result');
  }

  return formatted;
}
