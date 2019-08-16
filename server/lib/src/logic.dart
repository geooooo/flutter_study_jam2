import 'dart:math' as math;
import 'package:server/server.dart';

import 'player.dart';

class Logic {
  static const String humanMarker = FieldMarker.x;
  static const String computerMarker = FieldMarker.zero;

  List<String> field = [];
  int fieldSize;

  Player get firstStepPlayer {
    Player player;
    final number = math.Random.secure().nextInt(2);
    switch (number) {
      case 0:
        player = Player.human;
        break;
      case 1:
        player = Player.computer;
        break;
    }
    return player;
  }

  void printField() {
    field.forEach(print);
    print('');
  }

  void setFieldMarker(int row, int col, Player player) {
    String marker;
    switch (player) {
      case Player.human:
        marker = humanMarker;
        break;
      case Player.computer:
        marker = computerMarker;
        break;
    }

    field[row] = field[row].substring(0, col) + marker + field[row].substring(col + 1, fieldSize);
    printField();
  }

  Player initGame(int fieldSize) {
    this.fieldSize = fieldSize;

    field.clear();
    for (var i = 0; i < fieldSize; i++) {
      field.add(FieldMarker.empty * fieldSize);
    }

    return firstStepPlayer;
  }

  bool stepHuman(int row, int col) {
    setFieldMarker(row, col, Player.human);
    return checkWin(Player.human);
  }

  Map<String, Object> stepComputer() {
    int row;
    int col;

    do {
      row = math.Random.secure().nextInt(fieldSize);
      col = math.Random.secure().nextInt(fieldSize);
    } while (field[row][col] != FieldMarker.empty);

    setFieldMarker(row, col, Player.computer);
    final isWin = checkWin(Player.computer);

    return {
      'row': row,
      'col': col,
      'isWin': isWin,
    };
  }

  bool checkWin(Player player) {
    String marker;
    switch (player) {
      case Player.human:
        marker = humanMarker;
        break;
      case Player.computer:
        marker = computerMarker;
        break;
    }
  }
}