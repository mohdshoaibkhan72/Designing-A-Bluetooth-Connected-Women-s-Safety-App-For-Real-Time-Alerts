import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_steps/screens/available_devices/AvailableDevices.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.fcm_token, required this.phone_number});

  String fcm_token;
  String phone_number;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.arrow_back_ios, color: Colors.white, ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.more_horiz, color: Colors.white,)),
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
            Text("Devices", style: TextStyle(color: Colors.white, fontSize: 30),),
            SizedBox(height: 30,),
            Text("Connect to your devices and let your parents discover if you are in trouble.", style: TextStyle(color: Colors.white),),
            SizedBox(height: 120,),
            Expanded(child:
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async{
                      Position position = await Geolocator .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                      if(position != null){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AvailableDevices(fcm_token: widget.fcm_token, position: position, phone_number: widget.phone_number)));
                      }

                    },
                    child: Container(
                      height: 75,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, // Set border colo
                        ),
                        borderRadius: BorderRadius.circular(10), // Set border radius
                      ),
                      child: Row(
                        children: [
                          Text("Discover your devices", style: TextStyle(color: Colors.white, fontSize: 18),),
                          Expanded(child: SizedBox()),
                          Icon(Icons.arrow_forward_ios, color: Colors.white,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
            )
          ],
        ),
      ),
    );
  }
}
