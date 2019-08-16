import 'dart:io' as io;
import 'dart:convert';
import 'package:ansicolor/ansicolor.dart';
import 'package:models/models.dart';
import 'package:server/server.dart';

final logic = Logic();

void main() async {
  final port = 8081;
  final server = await runServer(port);
  print('Server run on port: $port');
  server.listen(requestHandler);
}

Future<io.HttpServer> runServer(port) async =>
    await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, port);

Future<void> requestHandler(io.HttpRequest request) async {
  final method = request.method.toLowerCase();
  final uri = request.uri.path;
  final body = utf8.decode(await request.single);

  log(method, uri, body);

  Serializable response;

  if (method == 'post' && uri == '/start_game') {
    response = startGameHandler(body);
  } else if (method == 'post' && uri == '/step_human') {
    response = stepHuman(body);
  } if (method == 'post' && uri == '/step_computer') {
    response = stepComputer(body);
  }

  request.response
    ..headers.set('Access-Control-Allow-Origin', '*')
    ..statusCode = io.HttpStatus.ok
    ..write(response.toJson())
    ..close();
}

void log(String method, String uri, String body) {
  final methodPen = new AnsiPen()..xterm(15)..xterm(9, bg: true);
  final uriPen = new AnsiPen()..xterm(39);
  final bodyPen = new AnsiPen()..xterm(15);

  print('${methodPen(method)} ${uriPen(uri)}\n${bodyPen(body)}\n');
}

StartGameResponse startGameHandler(String body) {
  final requestData = StartGameRequest.fromJson(body);
  final fieldSize = requestData.fieldSize;

  final firstStepPlayer = logic.initGame(fieldSize);

  return StartGameResponse(
    firstStepPlayer: firstStepPlayer,
  );
}

StepHumanResponse stepHuman(body) {
  final requestData = StepHumanRequest.fromJson(body);
  final row = requestData.row;
  final col = requestData.col;

  final isWin = logic.stepHuman(row, col);

  return StepHumanResponse(
    isWin: isWin,
  );
}

StepComputerResponse stepComputer(body) {
  final result = logic.stepComputer();

  return StepComputerResponse(
    row: result['row'],
    col: result['col'],
    isWin: result['isWin'],
  );
}