import 'package:http/http.dart' as http;
import 'package:models/models.dart';

Future<StartGameResponse> startGame(int fieldSize) async {
  final requestData = StartGameRequest(
    fieldSize: fieldSize,
  ).toJson();

  final response = await http.post(
      'http://localhost:8081/start_game',
      body: requestData,
  );

  return StartGameResponse.fromJson(response.body);
}

Future<StepHumanResponse> stepHuman(int row, int col) async {
  final requestData = StepHumanRequest(
    row: row,
    col: col,
  ).toJson();

  final response = await http.post(
    'http://localhost:8081/step_human',
    body: requestData,
  );

  return StepHumanResponse.fromJson(response.body);
}

Future<StepComputerResponse> stepComputer() async {
  final requestData = StepComputerRequest().toJson();

  final response = await http.post(
    'http://localhost:8081/step_computer',
    body: requestData,
  );

  return StepComputerResponse.fromJson(response.body);
}