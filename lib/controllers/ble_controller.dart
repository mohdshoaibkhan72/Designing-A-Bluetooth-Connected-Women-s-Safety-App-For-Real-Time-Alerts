import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController{

  FlutterBlue ble = FlutterBlue.instance;

  Future scanDevices() async{
    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    if(bluetoothScanStatus.isGranted){
      if(bluetoothConnectStatus.isGranted){
        await ble.startScan(timeout: Duration(seconds: 15));


        // Delay stopping the scan to allow time for devices to be discovered
        await Future.delayed(Duration(seconds: 15));
        ble.stopScan();

        ble.scanResults.listen((List<ScanResult> results) {
          print('Scanned Devices:');
          for (var result in results) {
            print('Device Name: ${result.device.name}, RSSI: ${result.rssi}');
          }
        });
      }
    }
  }

  Future<void> connectToDevice(BluetoothDevice device)async {
    await device?.connect(timeout: Duration(seconds: 15));

    device?.state.listen((isConnected) {
      if(isConnected == BluetoothDeviceState.connecting){
        print("Device connecting to: ${device.name}");
      }else if(isConnected == BluetoothDeviceState.connected){
        print("Device connected: ${device.name}");
      }else{
        print("Device Disconnected");
      }
    });

  }

  Stream<List<ScanResult>> get scanResults => ble.scanResults;

}