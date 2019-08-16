import 'dart:convert' show json;
import 'serializable.dart';

class StepHumanRequest implements Serializable {
  int row;
  int col;

  StepHumanRequest({this.row, this.col});

  @override
  factory StepHumanRequest.fromJson(String data) {
    final mapData = json.decode(data) as Map<String, Object>;
    return StepHumanRequest(
      row: mapData['row'] as int,
      col: mapData['col'] as int,
    );
  }

  @override
  String toJson() => json.encode(<String, Object>{
    'row': row,
    'col': col,
  });
}