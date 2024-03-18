import 'package:flutter/material.dart';
import 'package:lumiax_app/services/bluetooth.dart';
import 'package:lumiax_app/widgets/display_status.dart';

import '../features/lumiax_status.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<LumiaxStatus> data;

  Future<LumiaxStatus> getStatus() async {
    var service = await LumiaxService.create();
    await service.connect();
    var status = await service.getStatus();
    await service.disconnect();
    return status;
  }

  @override
  void initState() {
    super.initState();
    data = getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Solar Controller"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<LumiaxStatus>(
                future: getStatus(),
                builder: (BuildContext context, AsyncSnapshot<LumiaxStatus> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return LumiaxStatusDisplay(status: snapshot.data!);
                  }
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            setState(() {
              data = getStatus();
            })
          },
          tooltip: 'Scan',
          child: const Icon(Icons.bluetooth_searching),
        ));
  }
}
