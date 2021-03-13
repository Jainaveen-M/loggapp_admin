import 'dart:async';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_log_admin/user_info.dart';
import 'package:hexcolor/hexcolor.dart';
import 'user_creation.dart';
void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
String storedPasscode ="";
class _MyAppState extends State<MyApp> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  String name,role,img_url,code;
  bool pass;
// for password settings
 /* Future getPass(String a) async{
    storedPasscode =a;
  }

  _lockPass(String n,String i,String r,BuildContext context,bool p,String c){
    setState(() {
      name=n;
      role=r;
      img_url=i;
      pass =p;
      code = c;
    });
    getPass(storedPasscode);
    _showLockScreen(
      context,
      opaque: false,
      cancelButton: Text(
        'Cancel',
        style: const TextStyle(fontSize: 16, color: Colors.white),
        semanticsLabel: 'Cancel',
      ),
    );
  }
  _showLockScreen(BuildContext context,{bool opaque,Widget cancelButton,List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
            title: Text(
              'Enter App Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 4,
            bottomWidget: _buildPasscodeRestoreButton(),
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    if(storedPasscode == enteredPasscode){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>User(name,img_url,role,pass)));
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: FlatButton(
        child: Text(
          "Reset passcode",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        splashColor: Colors.white.withOpacity(0.4),
        highlightColor: Colors.white.withOpacity(0.2),
        onPressed: _resetAppPassword,
      ),
    ),
  );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nContact administrator",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            FlatButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed:() {},
            ),
          ],
        );
      },
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset("assets/onwords.png",height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.4,),
        backgroundColor: HexColor("#ffbf00"),
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
          Expanded(
            child: StreamBuilder(
              stream:Firestore.instance.collection('info').snapshots(),
              builder: (context,snapshot) {
                if (!snapshot.hasData) {
                  return Container( );
                }
                else {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot info = snapshot.data.documents[index];
                        return InkWell(
                          onTap: () {
                           /* getPass(info['lock'].toString());
                            print("pass ${info['lock'].toString()} ");
                            if(info['pass']==true){
                              _lockPass(info['name'],info['img_url'],info['role'],context,info['pass'],info['lock']);
                            }
                            else{*/
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>User(info['name'],info['img_url'],info['role'],info['pass'])));
                            //}
                           //_lockPass(info['name'],info['img_url'],info['role'],context);
                           //Navigator.push(context, MaterialPageRoute(builder: (context)=>User(info['name'],info['img_url'],info['role'])));
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.all(15),
                            child: Column(
                              children: [ //Image.network("${info['img_url']}")
                                AvatarGlow(
                                  glowColor: Colors.black,
                                  endRadius: 50.0,
                                  duration: Duration(milliseconds: 2000),
                                  repeat: true,
                                  showTwoGlows: true,
                                  repeatPauseDuration: Duration(milliseconds: 100),
                                  child: Material(
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      child: Image.network("${info['img_url']}",
                                      ),
                                      radius: 30.0,
                                    ),
                                  ),
                                ),
                                //SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                AutoSizeText( "${info['name']}",style: GoogleFonts.alice(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.white),),
                              ],
                            ),
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               begin: Alignment.bottomLeft,
                                 end: Alignment.topRight,
                                 colors: [
                                 Colors.deepOrangeAccent,
                                   Colors.orange[600],
                                   Colors.deepOrangeAccent
                               ]
                             ),
                             borderRadius: BorderRadius.circular(10),
                             boxShadow: [
                               BoxShadow(
                                 offset: Offset(4,4),
                                 blurRadius: 4,
                                 color: Colors.grey[200],
                               ),
                               BoxShadow(
                                 offset: Offset(-1,-1),
                                 blurRadius: 4,
                                 color: Colors.grey[200],
                               )
                             ]
                           ),
                          ),
                        );
                      } );
                }
              }
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (contex)=>User_Creation()));
        },
        backgroundColor: Colors.orange[700],
      ),
    );
  }
}
