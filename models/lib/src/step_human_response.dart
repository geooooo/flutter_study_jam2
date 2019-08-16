import 'dart:convert' show json;
import 'serializable.dart';

class StepHumanResponse implements Serializable {
  bool isWin;

  StepHumanResponse({this.isWin});

  @override
  factory StepHumanResponse.fromJson(String data) {
    final mapData = json.decode(data) as Map<String, Object>;
    return StepHumanResponse(
      isWin: mapData['isWin'] as bool,
    );
  }

  @override
  String toJson() => json.encode(<String, Object>{
    'isWin': isWin,
  });
}