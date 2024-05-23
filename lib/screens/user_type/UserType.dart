import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_steps/screens/parents_details/ParentsDetails.dart';
import 'package:safe_steps/screens/personal_details/PersonalDetails.dart';

class UserType extends StatefulWidget {
  UserType({super.key, required this.fcm_token});

  String? fcm_token;

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),

          centerTitle: true, // Center the title
          title: Text(
            'Safe Steps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Make the title bold if desired
            ),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            )
          ],
          backgroundColor: Colors.brown.shade400,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.brown.shade400, Colors.black],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalDetails()));
                  },
                  child: Container(
                    height: 60,
                    width: screenWidth*0.5,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Set border colo
                      ),
                      borderRadius: BorderRadius.circular(10), // Set border radius
                    ),
                    child: Center(child: Text("I am a Child", style: TextStyle(color: Colors.white, fontSize: 18),)),
                    ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ParentsDetails(fcmToken: widget.fcm_token,)));
                  },
                  child: Container(
                    height: 60,
                    width: screenWidth*0.5,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Set border colo
                      ),
                      borderRadius: BorderRadius.circular(10), // Set border radius
                    ),
                    child: Center(child: Text("I am a Parent", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  ),
                ),
                SizedBox(height: 100,)
              ],
            ),
          )
        ));
  }
}
