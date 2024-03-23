import 'package:flutter/material.dart';

import '../features/lumiax_status.dart';

class LumiaxStatusDisplay extends StatelessWidget {
  final LumiaxStatus status;

  const LumiaxStatusDisplay({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('SOC: ${status.soc}%'),
        const Text('PV Status:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('  Voltage: ${status.pvStatus.voltage}V'),
        Text('  Current: ${status.pvStatus.current}A'),
        Text('  Power: ${status.pvStatus.power}W'),
        Text('  Total: ${status.pvStatus.total}Wh'),
        const Text('Battery Status:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('  Voltage: ${status.battStatus.voltage}V'),
        Text('  Current: ${status.battStatus.current}A'),
        Text('  Temp: ${status.battStatus.temp}°C'),
        const Text('Load Status:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('  Voltage: ${status.loadStatus.voltage}V'),
        Text('  Current: ${status.loadStatus.current}A'),
        Text('  Power: ${status.loadStatus.power}W'),
        Text('  Total: ${status.loadStatus.total}Wh'),
      ],
    );
  }
}
