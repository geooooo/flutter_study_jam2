import 'dart:convert' show json;
import 'serializable.dart';

class StepComputerResponse implements Serializable {
  int row;
  int col;
  bool isWin;
  bool isFull;

  StepComputerResponse({this.row, this.col, this.isWin, this.isFull});

  @override
  factory StepComputerResponse.fromJson(String data) {
    final mapData = json.decode(data) as Map<String, Object>;
    return StepComputerResponse(
      row: mapData['row'] as int,
      col: mapData['col'] as int,
      isWin: mapData['isWin'] as bool,
      isFull: mapData['isFull'] as bool,
    );
  }

  @override
  String toJson() => json.encode(<String, Object>{
    'row': row,
    'col': col,
    'isWin': isWin,
    'isFull': isFull,
  });
}