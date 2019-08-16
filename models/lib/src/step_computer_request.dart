import 'dart:convert' show json;
import 'serializable.dart';

class StepComputerRequest implements Serializable {
  StepComputerRequest();

  @override
  factory StepComputerRequest.fromJson(String data) => StepComputerRequest();

  @override
  String toJson() => json.encode(<String, Object>{});
}