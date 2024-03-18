import 'package:flutter/material.dart';
import 'package:lumiax_app/services/bluetooth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  scan() async {
    var service = await LumiaxService.create();
    await service.connect();
    await service.getStatus();
    await Future.delayed(const Duration(seconds: 5), (){});
    await service.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Solar Controller"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Solar State",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        tooltip: 'Scan',
        child: const Icon(Icons.bluetooth_searching),
      )
    );
  }
}
