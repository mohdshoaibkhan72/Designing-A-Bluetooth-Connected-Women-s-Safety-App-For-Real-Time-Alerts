import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:easy_send_sms/easy_sms.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms/flutter_sms.dart';


@pragma('vm:entry-point')
void sending_sms(String text_message, List<String> list_receipents) async {
  String send_result = await sendSMS(message: text_message, recipients: list_receipents, sendDirect: true).catchError((err){
    print(err);
  });
  print(send_result);
}
void sendFCMNotification(String recipientToken, String title, String body) async {
  // Define FCM endpoint URL
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  // Define your server key obtained from Firebase Console
  final String serverKey = 'AAAAT9t3_zQ:APA91bHoVCOXvW8V_wMcR8yTJxF6Ih9Tq6MiORXsOCy7NxiuZdkn3_FT49RvdsjAb4KOgc987GKm9SmouH7E2jZuczru_cuPdqFiTIySqMGnE8bF6nwLDESgobSlOS13gMOPysaQAgI2';

  // Construct the notification payload
  Map<String, dynamic> notification = {
    'title': title,
    'body': body,
    'priority': 'high',
  };

  // Construct the message payload
  Map<String, dynamic> message = {
    'notification': notification,
    'to': recipientToken,
  };

  // Encode the message payload as JSON
  String jsonMessage = jsonEncode(message);

  // Send HTTP POST request to FCM endpoint
  await http.post(
    Uri.parse(fcmUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey', // Provide your server key here
    },
    body: jsonMessage,
  );
}


class AvailableDevices extends StatefulWidget {
  AvailableDevices({super.key, required this.fcm_token, required this.position, required this.phone_number});

  String phone_number;
  Position position;

  String fcm_token;

  @override
  State<AvailableDevices> createState() => _AvailableDevicesState();
}

class _AvailableDevicesState extends State<AvailableDevices> {


  final _easySmsPlugin = EasySms();

  Future<void> sendSms({required String phone, required msg}) async {
    try {
      await _easySmsPlugin.requestSmsPermission();
      await _easySmsPlugin.sendSms(phone: phone, msg: msg);
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  Widget buildPopup(BuildContext context) {
    showPopup(context);
    return SizedBox();
  }

  StreamSubscription? _discoveredDevicesSubscription1;
  StreamSubscription? _discoveredDevicesSubscription2;
  StreamSubscription? _discoveredDevicesSubscription3;

  String _platformVersion = 'Unknown';
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  int _deviceStatus = Device.disconnected;
  Uint8List _data = Uint8List(0);
  String _connected_device = "";


  @override
  void initState(){
    super.initState();
    initPlatformState();
    _discoveredDevicesSubscription1 = _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      setState(() {
        _deviceStatus = event;
        if (_deviceStatus == 0) {
          print("sending sms");
          String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${widget.position.latitude},${widget.position.longitude}';
          String message = "Your child is in trouble please help them. \n Their current location :\n ${googleUrl}";
          print(message);
          // sendSMS(message: "hello message sent", recipients: ["+917985458242"]);
          sendSms(phone: widget.phone_number, msg: message);

          // Call sendFCMNotification function with random token, title, and body

          sendFCMNotification(
               widget.fcm_token,
              'Emergency Notification',
              'Your child is in trouble please help them. \n Their current location : \n ${widget.position}'
          );
        }

      });
    });
    _discoveredDevicesSubscription2 = _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      setState(() {
        _data = Uint8List.fromList([..._data, ...event]);
      });
    });
  }

   showPopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Dialog'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a small popup.'),
                Text('You can customize it as per your needs.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _bluetoothClassicPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      _devices = res;
    });
  }

  Future<void> _scan() async {

    _discoveredDevicesSubscription1?.cancel();
    _discoveredDevicesSubscription2?.cancel();
    _discoveredDevicesSubscription3?.cancel();

    if (_scanning) {
      await _bluetoothClassicPlugin.stopScan();
      setState(() {
        _scanning = false;
      });
    } else {
      await _bluetoothClassicPlugin.startScan();
      _discoveredDevicesSubscription3 = _bluetoothClassicPlugin.onDeviceDiscovered().listen(
            (event) {
          print('Device discovered: ${event.name ?? event.address}');
          setState(() {
            _discoveredDevices = [..._discoveredDevices, event];
          });
        },
      );
      setState(() {
        _scanning = true;
      });
    }
  }
  @override
  void dispose() {
  _discoveredDevicesSubscription1?.cancel();
  _discoveredDevicesSubscription2?.cancel();
  _discoveredDevicesSubscription3?.cancel();
  super.dispose();
  }

  Future<void> _checkAndRequestPermissions() async {
    // Check if Bluetooth permissions are granted
    var status = await Permission.bluetooth.status;
    if (!status.isGranted) {
      // Bluetooth permissions are not granted, request them
      await Permission.bluetooth.request();
    }
  }
  @override
  Widget build(BuildContext context) {

    @override
    void initState() {
      super.initState();
      // Check and request Bluetooth permissions
      _checkAndRequestPermissions();
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked :
            (didPop) async {
          _discoveredDevicesSubscription1?.cancel();
          _discoveredDevicesSubscription2?.cancel();
          _discoveredDevicesSubscription3?.cancel();

        },
      child: Scaffold(
          appBar: AppBar(leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white, )),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.more_horiz, color: Colors.white,),
              )
            ],
            backgroundColor: Colors.brown.shade400,
      
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            height: screenHeight,
            width: screenWidth,
            decoration:BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.brown.shade400, Colors.black],
              ),
            ) ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Available Devices", style: TextStyle(color: Colors.white, fontSize: 30),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: _getDevices,
                        child: Icon(Icons.sync_outlined, color: Colors.white, size: 35,))
                  ],
                ),
                Text(_deviceStatus==2? "Status: Connected" : "Status: Disconnected", style: TextStyle(color: Colors.white), ),
                _deviceStatus == 1 ? CircularProgressIndicator() : SizedBox(),
                _deviceStatus == 2 ?  connectedDeviceMethod(_connected_device) : SizedBox(),


                ...[
                  for (var device in _devices)
                    GestureDetector(
                      onTap:
                        () async {
                          await _bluetoothClassicPlugin.connect(device.address,
                              "00001101-0000-1000-8000-00805f9b34fb");
                          setState(() {
                            _discoveredDevices = [];
                            _devices = [];
                            _connected_device = device.name?? device.address?? "";
                          });
                        },
                      child: Container(
                        height: 60,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Set border colo
                          ),
                          borderRadius: BorderRadius.circular(10), // Set border radius
                        ),
                        child: Row(
                          children: [
                            Text(device.name ?? device.address, style: TextStyle(color: Colors.white, fontSize: 18),),
                            Expanded(child: SizedBox()),
                            Icon(Icons.arrow_forward_ios, color: Colors.white,)
                          ],
                        ),
                      ),
                    )
                ],
                _deviceStatus == 2? disconnectMethod() : SizedBox(),
              ],
            ),
          ),
      
      ),
    );
  }

  TextButton disconnectMethod() {
    return TextButton(
                onPressed: _deviceStatus == Device.connected
                    ? () async {
                  await _bluetoothClassicPlugin.disconnect();
                }
                    : null,
                child: const Text("Disconnect", style: TextStyle(color: Colors.white),),
              );
  }

  Container connectedDeviceMethod(String _device_name) {
    return Container(
                height: 60,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // Set border colo
                  ),
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                child: Row(
                  children: [
                    Text(_device_name, style: TextStyle(color: Colors.white, fontSize: 18),),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, color: Colors.white,)
                  ],
                ),
              );
  }
}
