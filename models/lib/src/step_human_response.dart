import 'dart:convert' show json;
import 'serializable.dart';

class StepHumanResponse implements Serializable {
  bool isWin;
  bool isFull;

  StepHumanResponse({this.isWin, this.isFull});

  @override
  factory StepHumanResponse.fromJson(String data) {
    final mapData = json.decode(data) as Map<String, Object>;
    return StepHumanResponse(
      isWin: mapData['isWin'] as bool,
      isFull: mapData['isFull'] as bool,
    );
  }

  @override
  String toJson() => json.encode(<String, Object>{
    'isWin': isWin,
    'isFull': isFull,
  });
}