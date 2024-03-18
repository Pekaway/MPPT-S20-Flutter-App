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
        Text('SOC: ${status.soc}'),
        const Text('PV Status:'),
        Text('  Voltage: ${status.pvStatus.voltage}'),
        Text('  Current: ${status.pvStatus.current}'),
        Text('  Power: ${status.pvStatus.power}'),
        Text('  Total: ${status.pvStatus.total}'),
        const Text('Battery Status:'),
        Text('  Voltage: ${status.battStatus.voltage}'),
        Text('  Current: ${status.battStatus.current}'),
        Text('  Temp: ${status.battStatus.temp}'),
        const Text('Load Status:'),
        Text('  Voltage: ${status.loadStatus.voltage}'),
        Text('  Current: ${status.loadStatus.current}'),
        Text('  Power: ${status.loadStatus.power}'),
        Text('  Total: ${status.loadStatus.total}'),
      ],
    );
  }
}
