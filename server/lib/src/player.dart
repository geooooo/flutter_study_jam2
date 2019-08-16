class Player {
  static const Player human = Player._('игрок');
  static const Player computer = Player._('компьютер');
  static const List<Player> players = [
    Player.human,
    Player.computer,
  ];

  final String _name;

  const Player._(this._name);

  factory Player.fromString(String name) =>
    players.firstWhere((player) => player._name == name);

  @override
  String toString() => _name;
}