import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../user_identity.dart';

class QuestionEditException implements Exception {
  QuestionEditException(this.message);
  final String message;

  @override
  String toString() => 'QuestionEditException: $message';
}

class EditedQuestion {
  EditedQuestion({
    required this.original,
    required this.edited,
    required this.usedAI,
  });

  final String original;
  final String edited;
  final bool usedAI;

  factory EditedQuestion.fromJson(Map<String, dynamic> json) => EditedQuestion(
        original: (json['original'] as String? ?? '').trim(),
        edited: (json['edited'] as String? ?? '').trim(),
        usedAI: json['usedAI'] as bool? ?? false,
      );
}

Future<EditedQuestion> editQuestion({
  required String question,
  required String locale,
}) async {
  final uri = buildApiUri('api/questions/edit');
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
    throw QuestionEditException('Network error: $error');
  }

  if (response.statusCode != 200) {
    throw QuestionEditException(
      'Edit request failed (${response.statusCode}): ${response.body}',
    );
  }

  final Map<String, dynamic> payload =
      jsonDecode(response.body) as Map<String, dynamic>;
  if (payload['success'] != true) {
    final error = payload['error'];
    throw QuestionEditException(
      'Edit request failed: ${error ?? payload}',
    );
  }

  final data = payload['data'] as Map<String, dynamic>;
  return EditedQuestion.fromJson(data);
}
