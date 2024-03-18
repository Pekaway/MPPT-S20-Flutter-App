import 'dart:async';

import 'package:convert/convert.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lumiax_app/features/lumiax_status.dart';

import 'conversion.dart';

class LumiaxService {
  final BluetoothDevice device;

  final notifyUUID = Guid("0000ff01-0000-1000-8000-00805f9b34fb");
  final enableUUID = Guid("0000ff03-0000-1000-8000-00805f9b34fb");
  final getStatusUUID = Guid("0000ff02-0000-1000-8000-00805f9b34fb");
  final getStatusPayload = hex.decode("fe043030002bab15");

  late final BluetoothCharacteristic notifyCharacteristic;
  late final BluetoothCharacteristic enableCharacteristic;
  late final BluetoothCharacteristic getStatusCharacteristic;

  bool isInitialized = false;

  Completer<List<int>> data = Completer();
  List<int> dataAccumulator = [];

  LumiaxService({required this.device});

  connect() async {
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

    isInitialized = true;
  }

  dataHandler(List<int> value) {
    if (!isInitialized) {
      throw Exception("LumiaxService not initialized!");
    }

    dataAccumulator += value;

    if (dataAccumulator.length >= 91) {
      data.complete(dataAccumulator);
    }
  }

  Future<LumiaxStatus> getStatus() async {
    if (!isInitialized) {
      throw Exception("LumiaxService not initialized!");
    }

    var subscription = notifyCharacteristic.onValueReceived.listen(dataHandler);
    device.cancelWhenDisconnected(subscription);
    await notifyCharacteristic.setNotifyValue(true);

    await enableCharacteristic.write([0x01, 0x00]);

    await getStatusCharacteristic.write(getStatusPayload);

    var result = await data.future;

    var conversion = ConversionService(dataList: result);
    var status = LumiaxStatus(
      soc: conversion.getInt4(46),
      pvStatus: PvStatus(
        voltage: conversion.getUInt8(63) / 100,
        current: conversion.getInt8(65) / 100,
        power: conversion.getUInt8(67) / 100,
        total: conversion.getUInt8(73) / 100,
      ),
      battStatus: BattStatus(
        voltage: conversion.getUInt8(47) / 100,
        current: conversion.getInt8(49) / 100,
        temp: conversion.getUInt8(17) / 100,
      ),
      loadStatus: LoadStatus(
        voltage: conversion.getUInt8(55) / 100,
        current: conversion.getInt8(57) / 100,
        power: conversion.getUInt8(59) / 100,
        total: conversion.getUInt8(79) / 100,
      ),
    );

    return status;
  }

  disconnect() async {
    await device.disconnect();
  }

  static create() async {
    if (await FlutterBluePlus.isSupported == false) {
      throw Exception("Bluetooth not supported by this device");
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
