class LumiaxStatus {
  final int soc;
  final PvStatus pvStatus;
  final BattStatus battStatus;
  final LoadStatus loadStatus;

  LumiaxStatus(
      {required this.soc,
      required this.pvStatus,
      required this.battStatus,
      required this.loadStatus});
}

class PvStatus {
  final double voltage;
  final double current;
  final double power;
  final double total;

  PvStatus(
      {required this.voltage,
      required this.current,
      required this.power,
      required this.total});
}

class BattStatus {
  final double voltage;
  final double current;
  final double temp;

  BattStatus(
      {required this.voltage, required this.current, required this.temp});
}

class LoadStatus {
  final double voltage;
  final double current;
  final double power;
  final double total;

  LoadStatus(
      {required this.voltage,
      required this.current,
      required this.power,
      required this.total});
}
