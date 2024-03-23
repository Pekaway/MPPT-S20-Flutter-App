import 'package:flutter/material.dart';
import 'package:lumiax_app/services/lumiax.dart';
import 'package:lumiax_app/widgets/display_status.dart';

import '../features/lumiax_status.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late Future<LumiaxService> service;

  Future<LumiaxService> initService() async {
    var service = await LumiaxService.create();
    await service.connect();

    return service;
  }

  @override
  void dispose() {
    super.dispose();
    service.then((value) => {value.disconnect()});
  }

  @override
  void initState() {
    super.initState();
    service = initService();
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
              FutureBuilder<LumiaxService>(
                future: service,
                builder: (BuildContext context,
                    AsyncSnapshot<LumiaxService> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Connecting to SolarLife...");
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return FutureBuilder<LumiaxStatus>(
                      future: snapshot.data!.getStatus(),
                      builder: (BuildContext context,
                          AsyncSnapshot<LumiaxStatus> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Retrieving status...");
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return LumiaxStatusDisplay(status: snapshot.data!);
                        }
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            setState(() {})
          },
          tooltip: 'Scan',
          child: const Icon(Icons.bluetooth_searching),
        ));
  }
}
