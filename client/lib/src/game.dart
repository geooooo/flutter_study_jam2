import 'dart:html';
import 'step.dart';
import 'field_marker.dart' as field_marker;

class Game {
  static const fieldColumnXClass = 'game-field__col_x';
  static const fieldColumn0Class = 'game-field__col_0';

  Step step;
  int humanPoints;
  int computerPoints;
  List<String> field;

  int fieldSize;
  HtmlElement stepPlayerHumanElement;
  HtmlElement stepPlayerComputerElement;
  HtmlElement pointsHumanElement;
  HtmlElement pointsComputerElement;
  HtmlElement fieldElement;

  Game({this.fieldSize = 3}) {
    getElements();
    init();
  }

  void getElements() {
    stepPlayerHumanElement = window.document.querySelector('.step-player__human');
    stepPlayerComputerElement = window.document.querySelector('.step-player__computer');
    pointsHumanElement = window.document.querySelector('.game-points__human');
    pointsComputerElement = window.document.querySelector('.game-points__computer');
    fieldElement = window.document.querySelector('.game-field');
  }

  void init() {
    humanPoints = 0;
    computerPoints = 0;
    field = [];

    hideElement(stepPlayerHumanElement);
    hideElement(stepPlayerComputerElement);
    showPoints();
    buildField();
    setEventHandlers();
    initFirstStep();
  }

  void initFirstStep() {
    // get first step
    showStep();
  }

  void setEventHandlers() {
    fieldElement.addEventListener('click', onClickGameField);
  }

  void onClickGameField(Event event) {
    if (step != Step.human) {
      return;
    }

    final fieldColElement = event.target as HtmlElement;
    fieldColElement.classes.add(fieldColumnXClass);
    final rowNumber = int.parse(fieldColElement.getAttribute('data-row'));
    final colNumber = int.parse(fieldColElement.getAttribute('data-col'));
    setFieldMarker(rowNumber, colNumber);
    computerStep();
  }

  void computerStep() {
    step = Step.computer;
    showStep();
    // step computer
    step = Step.human;
    showStep();
  }

  void buildField() {
    fieldElement.innerHtml = '';
    for (var i = 0; i < fieldSize; i++) {
      field.add(field_marker.empty * fieldSize);
      fieldElement.append(buildFieldRowElement(i));
    }
    printField();
  }

  void setFieldMarker(int row, int col) {
    String marker;
    switch (step) {
      case Step.human:
        marker = field_marker.x;
        break;
      case Step.computer:
        marker = field_marker.zero;
        break;
    }
    field[row] = field[row].substring(0, col) + marker + field[row].substring(col + 1, fieldSize);
    printField();
  }

  HtmlElement buildFieldRowElement(int rowNumber) {
    final rowElement = Element.div()
      ..className = 'game-field__row';
    for (var i = 0; i < fieldSize; i++) {
      final colElement = Element.div()
        ..className = 'game-field__col'
        ..setAttribute('data-row', rowNumber.toString())
        ..setAttribute('data-col', i.toString());
      rowElement.append(colElement);
    }
    return rowElement;
  }

  void printField() =>
      field.forEach((line) => print(line+'\n'));

  void showStep() {
    switch (step) {
      case Step.human:
        showElement(stepPlayerHumanElement);
        break;
      case Step.computer:
        showElement(stepPlayerComputerElement);
        break;
    }
  }

  void showPoints() {
    pointsHumanElement.innerHtml = humanPoints.toString();
    pointsComputerElement.innerHtml = computerPoints.toString();
  }

  void hideElement(HtmlElement element) =>
    element.style.display = 'none';

  void showElement(HtmlElement element) =>
    element.style.display = '';
}