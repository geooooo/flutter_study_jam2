import 'dart:convert' show json;
import 'serializable.dart';

class StartGameRequest implements Serializable {
  int fieldSize;

  StartGameRequest({this.fieldSize});

  @override
  factory StartGameRequest.fromJson(String data) {
    final mapData = json.decode(data) as Map<String, Object>;
    return StartGameRequest(
        fieldSize: mapData['fieldSize'] as int,
    );
  }

  @override
  String toJson() => json.encode(<String, Object>{
    'fieldSize': fieldSize,
  });
}