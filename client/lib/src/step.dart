class Step {
  static const Step human = Step._('игрок');
  static const Step computer = Step._('компьютер');

  final String _name;

  const Step._(this._name);

  @override
  String toString() => _name;
}