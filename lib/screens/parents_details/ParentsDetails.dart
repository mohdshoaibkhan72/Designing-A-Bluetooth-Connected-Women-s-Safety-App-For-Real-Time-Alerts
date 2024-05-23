import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_steps/screens/available_devices/AvailableDevices.dart';
import 'package:safe_steps/screens/dashboard/Dashboard.dart';
import 'package:safe_steps/screens/parent_dashboard/ParentDashboard.dart';

class ParentsDetails extends StatefulWidget {
  ParentsDetails({super.key, required this.fcmToken});

  String? fcmToken;

  @override
  State<ParentsDetails> createState() => _ParentsDetailsState();
}

class _ParentsDetailsState extends State<ParentsDetails> {

  TextEditingController parentNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  uploadParentDetails(String parentName, int code, String phoneNumber){
    FirebaseFirestore.instance.collection("Users").doc(parentName).set({
      "Parent Name": parentName,
      "token" : widget.fcmToken,
      "code" : code,
      "phone_number": phoneNumber

    }).then((value) {
      print("Data inserted");
    });
  }
  int generateRandomNumber() {
    // Create an instance of Random class
    Random random = Random();
    // Generate a random 6-digit number
    int randomNumber = random.nextInt(900000) + 100000;

    return randomNumber;
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
            Text("Enter Parent's Details", style: TextStyle(color: Colors.white, fontSize: 30),),
            Expanded(child:
            Center(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  TextField(
                    controller: parentNameController,
                    decoration: InputDecoration(
                    labelText: "Parent's name",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                    focusedBorder: UnderlineInputBorder( // Change focused border color
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder( // Change enabled border color
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                    style: TextStyle(color: Colors.white),

                  ),
                  SizedBox(height: 20,),

                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                    focusedBorder: UnderlineInputBorder( // Change focused border color
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder( // Change enabled border color
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                    style: TextStyle(color: Colors.white),

                  ),
                  SizedBox(height: 20,),

                  TextField(decoration: InputDecoration(

                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                    focusedBorder: UnderlineInputBorder( // Change focused border color
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder( // Change enabled border color
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                    style: TextStyle(color: Colors.white),
                  ),



                  Expanded(child: SizedBox()),

                  ElevatedButton(
                    onPressed: (){
                      int r_num = generateRandomNumber();
                      uploadParentDetails(parentNameController.text.toString(), r_num, phoneNumberController.text.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>ParentDashboard(code: r_num.toString(),)));
                    }, child: Container(width: double.infinity, height: 55, child: Center(child: Text("NEXT", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),))),style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set background color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Set border radius
                        // side: BorderSide(color: Colors.red), // Set border color
                      ),
                    ),
                  ),),


                  SizedBox(height: 30,)

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
