import 'package:convert/convert.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class LumiaxService {
  final BluetoothDevice device;
  BluetoothCharacteristic? notifyCharacteristic;
  BluetoothCharacteristic? enableCharacteristic;
  BluetoothCharacteristic? getStatusCharacteristic;

  final notifyUUID = Guid("0000ff01-0000-1000-8000-00805f9b34fb");
  final enableUUID = Guid("0000ff03-0000-1000-8000-00805f9b34fb");
  final getStatusUUID = Guid("0000ff02-0000-1000-8000-00805f9b34fb");
  final getStatusPayload = hex.decode("fe043030002bab15");

  LumiaxService({required this.device});

  connect() async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color:true);
    await device.connect();

    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.uuid == notifyUUID) {
          notifyCharacteristic = c;
          continue;
        }
        if (c.uuid == enableUUID) {
          enableCharacteristic = c;
          continue;
        }
        if (c.uuid == getStatusUUID) {
          getStatusCharacteristic = c;
          continue;
        }
      }
    }
  }

  getStatus() async {
    if (getStatusCharacteristic == null) {
      throw Exception("getStatusCharacteristic is null");
    }
    if (notifyCharacteristic == null) {
      throw Exception("notifyCharacteristic is null");
    }
    if (enableCharacteristic == null) {
      throw Exception("enableCharacteristic is null");
    }

    var subscription = notifyCharacteristic!.onValueReceived.listen((value) {
      print("Received: $value");
    });
    device.cancelWhenDisconnected(subscription);
    await notifyCharacteristic!.setNotifyValue(true);

    await enableCharacteristic!.write([0x01,0x00]);

    await getStatusCharacteristic!.write(getStatusPayload);
  }

  disconnect() async {
    await device.disconnect();
  }

  static create() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    BluetoothDevice? scannedDevice;

    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          scannedDevice = results.last.device;
          FlutterBluePlus.stopScan();
        }
      },
      onError: (e) => throw e,
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    await FlutterBluePlus.startScan(
        withNames: ["SolarLife"], timeout: Duration(seconds: 15));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    if (scannedDevice == null) {
      throw Exception("No device found");
    } else {
      return LumiaxService(device: scannedDevice!);
    }
  }

  subscribe() async {}
}
