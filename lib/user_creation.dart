import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class User_Creation extends StatefulWidget {
  @override
  _User_CreationState createState() => _User_CreationState();
}

class _User_CreationState extends State<User_Creation> {
  String name,role,img_url,passcode;
  bool pass = false;
  createDate(){
    Map<String,dynamic> eventinfo ={
      "name":name,
      "role":role,
      "img_url":img_url,
      "pass":pass,
      "lock":passcode
    };
    Firestore.instance.collection('info').document(name).setData(eventinfo);
  }
  createLogDate(){
    Map<String,dynamic> eventinfo ={
      "name":name,
      "role":role,
      "status":"out",
    };
    Firestore.instance.collection('log_details').document(name).setData(eventinfo);
  }

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Creation",style: GoogleFonts.alice(fontSize: 20,fontWeight: FontWeight.w400),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.grey[600],
                    Colors.grey[700],
                  ]
              )
          ),
        ),
      ),
      body: Container(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange[700],width: 2.0),
                      ),
                    ),
                    onChanged: (String title){
                      name=title;

                    },
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter the Name';
                      }
                      else{
                        return null;
                      }
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Role",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange[700],width: 2.0),
                      ),
                    ),
                    onChanged: (String title){
                      role=title;

                    },
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter role';
                      }
                      else{
                        return null;
                      }
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Photo Url",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange[700],width: 2.0),
                      ),
                    ),
                    onChanged: (String title){
                      img_url=title;

                    },
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter image url';
                      }
                      else{
                        return null;
                      }
                    }
                ),
              ),
              RaisedButton(onPressed: (){
                if(_key.currentState.validate()){
                  createDate();
                  createLogDate();
                  Navigator.pop(context);
                }
              },
                child: Text("Creat",style: GoogleFonts.alice(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.orange[700],

              )
            ],
          ),
        ),
      ),
    );
  }
}
