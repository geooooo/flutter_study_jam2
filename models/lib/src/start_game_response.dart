import 'dart:convert' show json;
import 'package:server/server.dart' show Player;
import 'serializable.dart';

class StartGameResponse implements Serializable {
  Player firstStepPlayer;

  StartGameResponse({this.firstStepPlayer});

  @override
  factory StartGameResponse.fromJson(String data) {
    final mapData = json.decode(data) as Map<String, Object>;
    return StartGameResponse(
        firstStepPlayer: Player.fromString(mapData['firstStepPlayer'])
    );
  }

  @override
  String toJson() => json.encode(<String, Object>{
    'firstStepPlayer': firstStepPlayer.toString(),
  });
}