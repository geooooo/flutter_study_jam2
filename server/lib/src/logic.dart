import 'dart:math' as math;
import 'package:server/server.dart';

import 'player.dart';

class Logic {
  // Маркеры игроков на поле: крестик, нолик
  static const String humanMarker = FieldMarker.x;
  static const String computerMarker = FieldMarker.zero;

  // Игровое поле, изначально будет выглядеть примерно так
  // ###
  // ###
  // ###
  List<String> field = [];
  // Размер игрового поля
  int fieldSize;

  // Геттер для определения кто из игроков будет ходить первым
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

  // Отладочная печать игрового поля
  void printField() {
    field.forEach(print);
    print('');
  }

  // Запись маркера игрока на игровом поле в заданой позиции
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

  // Инициализация игры, вызывается каждый раз при начале партии
  Player initGame(int fieldSize) {
    this.fieldSize = fieldSize;

    // Очистка поля и заполнения пустыми значениями
    field.clear();
    for (var i = 0; i < fieldSize; i++) {
      field.add(FieldMarker.empty * fieldSize);
    }

    // Определяем и возвращаем игрока, который будет ходить первым
    return firstStepPlayer;
  }

  // Ход игрока
  Map<String, Object> stepHuman(int row, int col) {
    setFieldMarker(row, col, Player.human);
    return {
      'isWin': checkWin(Player.human),
      'isFull': checkFull(),
    };
  }

  // Ход компьютера и запуск "ИИ"
  Map<String, Object> stepComputer() {
    int row = 0;
    int col = 0;

    setFieldMarker(row, col, Player.computer);

    return {
      'row': row,
      'col': col,
      'isWin': checkWin(Player.computer),
      'isFull': checkFull(),
    };
  }

  // Проверка что игрок победил
  bool checkWin(Player player) {
    return false;
  }

  // Проверка полного заполнения игрового поля
  bool checkFull() {
    return false;
  }
}