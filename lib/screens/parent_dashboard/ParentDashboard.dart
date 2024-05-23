import 'package:flutter/material.dart';

class ParentDashboard extends StatefulWidget {
  ParentDashboard({super.key, required this.code});

  String code;
  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter Parent's Details", style: TextStyle(color: Colors.white, fontSize: 30),),
              Expanded(child:
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("Get your child's realtime update. \n Enter the given 6 digit security code in you child's app. \n ${widget.code}", style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),),
                    SizedBox(height: 80,)

                  ],
                ),
              )
              )
            ],
          ),
        ));
  }
}
