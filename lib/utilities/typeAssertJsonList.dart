import 'dart:convert';

List<T> typeAssertJsonList<T>(
  String jsonString,
  T Function(Map<String, dynamic>) fromJson,
) {
  final List<dynamic> decodedString = jsonDecode(jsonString);
  final List<T> targetClassList = [];

  for (var iterable in decodedString) {
    targetClassList.add(fromJson(iterable as Map<String, dynamic>));
  }

  return targetClassList;
}
