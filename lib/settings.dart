import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class settings extends StatefulWidget {
  String name;

  settings(this.name);
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  String password,cpassword;

  createDate(){
    CollectionReference collectionReference = Firestore.instance.collection('info');
    Map<String,dynamic> lockinfo ={
      "lock":password,
      "pass":true,
    };
    collectionReference.document(widget.name).updateData(lockinfo);
  }
  String nul;
  removePass(){
    CollectionReference collectionReference = Firestore.instance.collection('info');
    Map<String,dynamic> lockinfo ={
      "lock":password,
      "pass":false,
    };
    collectionReference.document(widget.name).updateData(lockinfo);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy"),
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
      body: Column(
        children: [
          InkWell(
            onTap: (){
              Alert(
                  context: context,
                  title: "Set 4 digit PIN ",
                  content: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline),
                          labelText: 'PIN',
                        ),
                        onChanged: (String lock){
                          password = lock;
                        },
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Confirm PIN',
                        ),
                        onChanged: (String lock){
                          cpassword = lock;
                        },
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: () {
                        if(password == cpassword && password.length==4 && cpassword.length==4 ){
                          createDate();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Lock",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();

            },
            child: Container(
              height: MediaQuery.of(context).size.height*0.09,
              width: MediaQuery.of(context).size.width*1,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.security,color: Colors.grey[700],),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  Text("Protect your profile",style: GoogleFonts.alice(fontSize: 16,fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Alert(
                context: context,
                type: AlertType.info,
                title: "Are you sure?",
                desc: "you want to remove passcode?",
                buttons: [
                  DialogButton(
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 60,
                    color: Colors.orange[700],
                  ),
                  DialogButton(
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        password=nul;
                      });
                      removePass();
                      Navigator.pop(context);
                    },
                    width: 60,
                    color: Colors.orange[700],
                  ),
                ],
              ).show();
            },
            child: Container(
              height: MediaQuery.of(context).size.height*0.09,
              width: MediaQuery.of(context).size.width*1,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.lock_open_rounded,color: Colors.grey[700],),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  Text("Remove passcode",style: GoogleFonts.alice(fontSize: 16,fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
