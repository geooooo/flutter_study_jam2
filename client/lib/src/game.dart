import 'dart:async';
import 'dart:html';
import 'http_api.dart' as http_api;
import 'package:server/server.dart' show Player;

// TODO: кто найдет здесь баг с асинхронностью ? :)

class Game {
  // Имена классов HTML элементов, чтобы отображать маркеры игроков
  static const String humanMarkerClass = 'field__col_x';
  static const String computerMarkerClass = 'field__col_0';

  // Количество очков игрока
  int humanPoints = 0;
  // Количество очков компьютера
  int computerPoints = 0;
  // Игрок, который ходит в данный момент
  Player currentPlayer;
  // Размер игрового поля
  int fieldSize;

  // Ссылкм на HTML элементы
  HtmlElement playerHumanElement;
  HtmlElement playerComputerElement;
  HtmlElement pointsHumanElement;
  HtmlElement pointsComputerElement;
  HtmlElement fieldElement;
  HtmlElement resetButtonElement;

  Game({this.fieldSize = 3}) {
    getElements();
    // Установка обработчиков событий на странице
    setEventHandlers();
    // Инициализация игры
    init();
  }

  // Получаем ссылки на HTML элементы в документе
  void getElements() {
    playerHumanElement = window.document.querySelector('.player__human');
    playerComputerElement = window.document.querySelector('.player__computer');
    pointsHumanElement = window.document.querySelector('.points__human');
    pointsComputerElement = window.document.querySelector('.points__computer');
    fieldElement = window.document.querySelector('.field');
    resetButtonElement = window.document.querySelector('button.reset');
  }

  // Инициализация игрового процесса
  Future<void> init() async {
    // Изначально скрываем метки игроков
    hideElement(playerHumanElement);
    hideElement(playerComputerElement);
    // Выводим текущее количество очков каждого игрока
    showPoints();
    // Инициализация игрового поля и начало игры
    initField();
    await initFirstPlayer();
  }

  // Определение того, кто ходит первым и начало игры
  Future<void> initFirstPlayer() async {
    // Запрос на сервер о начале игры и выбор игрока,
    // который будет ходить первым
    final data = await http_api.startGame(fieldSize);
    currentPlayer = data.firstStepPlayer;

    showPlayer();

    if (currentPlayer == Player.computer) {
      await stepComputer();
    }
  }

  // Обработчик клика мышкой на игровом поле
  Future<void> onClickFieldElement(Event event) async {
    // Если сейчас ход компьютера - игнорировать нажатие
    if (currentPlayer != Player.human) {
      return;
    }

    final fieldColElement = event.target as HtmlElement;
    final rowNumber = int.parse(fieldColElement.getAttribute('data-row'));
    final colNumber = int.parse(fieldColElement.getAttribute('data-col'));

    // Проверка что ячейка уже занята
    if (fieldColElement.classes.contains(humanMarkerClass)) {
      return;
    }

    await stepHuman(rowNumber, colNumber);
  }

  // Обработчик нажатия по кнопке "заново", начало новой партии
  Future<void> onClickResetButtonElement(Event event) async =>
    await init();

  // Шаг игрока
  Future<void> stepHuman(int row, int col) async {
    // Если ячейка была занята, ход игрока не проходит
    final isOk = setFieldMarker(row, col);
    if (!isOk) {
      return;
    }

    // Сообщить серверу о ходе игрока
    final response = await http_api.stepHuman(row, col);
    final isWin = response.isWin;
    final isFull = response.isFull;

    // Проверка игровой ситуации на победу
    if (isWin) {
      // Победа одного из игроков
      win();
      return;
    }

    // Проверка на ничью
    if (isFull) {
      draw();
      return;
    }

    // Передать ход компьютеру
    currentPlayer = Player.computer;
    showPlayer();
    await stepComputer();
  }

  // Ход компьютера
  Future<void> stepComputer() async {
    // Искуственная задержка: как будто компьютер задумался над ходом
    await Future.delayed(Duration(milliseconds: 500));

    final response = await http_api.stepComputer();
    final isWin = response.isWin;
    final isFull = response.isFull;
    final row = response.row;
    final col = response.col;

    setFieldMarker(row, col);

    // Проверка на выигрыш
    if (isWin) {
      // Победа одного из игроков
      win();
      return;
    }

    // Проверка на ничью
    if (isFull) {
      draw();
      return;
    }

    // Передать ход игроку
    currentPlayer = Player.human;
    showPlayer();
  }

  // Инициализация игрового поля
  void initField() {
    fieldElement.children.clear();
    for (var i = 0; i < fieldSize; i++) {
      fieldElement.append(buildFieldRowElement(i));
    }
  }

  // Победа одного из игроков
  void win() {
    switch (currentPlayer) {
      case Player.human:
        humanPoints++;
        window.alert('Победил ${Player.human}');
        break;
      case Player.computer:
        computerPoints++;
        window.alert('Победил ${Player.computer}');
        break;
    }
  }

  // Ничья
  void draw() {
    window.alert('Победила дружба :)');
  }

  // Установка маркера на игровом поле: крестик или нолик
  bool setFieldMarker(int row, int col) {
    final rowElement = fieldElement.querySelectorAll('.field__row')[row];
    final colElement = rowElement.querySelectorAll('.field__col')[col];

    final isNotFree = colElement.classes.contains(humanMarkerClass) ||
                      colElement.classes.contains(computerMarkerClass);
    if (isNotFree) {
      return false;
    }

    String fieldColumnClass;
    switch (currentPlayer) {
      case Player.human:
        fieldColumnClass = humanMarkerClass;
        break;
      case Player.computer:
        fieldColumnClass = computerMarkerClass;
        break;
    }

    colElement.classes.add(fieldColumnClass);
    return true;
  }

  // Создание строки игрового поля, содержащей ячейки
  HtmlElement buildFieldRowElement(int rowNumber) {
    final rowElement = Element.div()
      ..className = 'field__row';

    for (var i = 0; i < fieldSize; i++) {
      final colElement = Element.div()
        ..className = 'field__col'
        ..setAttribute('data-row', rowNumber.toString())
        ..setAttribute('data-col', i.toString());
      rowElement.append(colElement);
    }

    return rowElement;
  }

  // Установить обработчики событий на HTML элементах
  void setEventHandlers() {
    // По клику на игровое поле вызовется функция-обработчик
    fieldElement.addEventListener('click', onClickFieldElement);
    // По клику по кнопке начинается новая партия
    resetButtonElement.addEventListener('click', onClickResetButtonElement);
  }

  // Выводит метку текущего игрока
  void showPlayer() {
    switch (currentPlayer) {
      case Player.human:
        hideElement(playerComputerElement);
        showElement(playerHumanElement);
        break;
      case Player.computer:
        hideElement(playerHumanElement);
        showElement(playerComputerElement);
        break;
    }
  }

  // Показывает текущие очки игроков
  void showPoints() {
    pointsHumanElement.innerHtml = humanPoints.toString();
    pointsComputerElement.innerHtml = computerPoints.toString();
  }

  // Скрывает HTML элемент
  void hideElement(HtmlElement element) =>
    element.style.display = 'none';

  // Показывает HTML элемент
  void showElement(HtmlElement element) =>
    element.style.display = '';
}