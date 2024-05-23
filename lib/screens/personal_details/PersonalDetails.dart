import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_steps/screens/dashboard/Dashboard.dart';
import 'package:safe_steps/screens/parents_details/ParentsDetails.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController parentCodeController = TextEditingController();
  String? fetchedToken;
  String? parentPhoneNumber;

  Future<String> fetchToken(String code) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users").where('code', isEqualTo: int.parse(code)).get();

    if(querySnapshot.docs.isNotEmpty){
      var documentSnapshot = querySnapshot.docs.first;
      var fcm_token = documentSnapshot['token'];
      var phone_number = documentSnapshot['phone_number'];
      print("Retrieved fcm token :   ${fcm_token}");
      print("Retrieved parent phone number : ${phone_number}");
      setState(() {
        fetchedToken = fcm_token;
        parentPhoneNumber = phone_number;
      });
      return fcm_token;

    }
    print("Empty object recieved");
    return "";
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
            Text("Enter Your Details", style: TextStyle(color: Colors.white, fontSize: 30),),
            Expanded(child:
             Center(
               child: Column(
                 children: [
                   SizedBox(height: 30,),
                   TextField(decoration: InputDecoration(
                     labelText: "Enter name",
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

                   SizedBox(height: 20,),

                   TextField(
                     controller: parentCodeController,
                     decoration: InputDecoration(

                     labelText: "Parent's Code",
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
                     onPressed: ()async{
                       await fetchToken(parentCodeController.text);
                       if(fetchedToken!=null)

                     Navigator.push(context, MaterialPageRoute(builder: (context)  => Dashboard(fcm_token: fetchedToken!, phone_number: parentPhoneNumber!)));
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
