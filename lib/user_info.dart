import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:smart_log_admin/main.dart';
import 'package:smart_log_admin/settings.dart';
import 'package:smart_log_admin/task_creation.dart';
import 'package:smart_log_admin/task_details.dart';
import 'package:smart_log_admin/task_done.dart';
import 'log_history.dart';
import 'package:date_time_format/date_time_format.dart';

class User extends StatefulWidget {
  String user_name;
  String img_url;
  String role;
  bool pass;
  User(this.user_name,this.img_url,this.role,this.pass);
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final GlobalKey<SlideActionState> _key = GlobalKey();
  String res;
  String date;
  String status;
  String check;
  int count;
  createDate(){
    CollectionReference collectionReference = Firestore.instance.collection('log_details').document(widget.user_name).collection("log_info");

    Map<String,dynamic> eventinfo ={
      "date":date,
    };
    collectionReference.document(date).setData(eventinfo);
  }
  createState(){
    CollectionReference collectionReference = Firestore.instance.collection('log_details');

    Map<String,dynamic> eventinfo ={
      "status":status,
    };
    collectionReference.document(widget.user_name).updateData(eventinfo);
  }

  Future CheckStatus() async{
    QuerySnapshot qs= await Firestore.instance.collection('log_details').getDocuments();
    for(int i=0;i<qs.documents.length;i++){
      if(qs.documents[i]['name']==widget.user_name){
        setState(() {
          check = qs.documents[i]['status'].toString();
        });
        return;
      }
    }
  }
  Future TaskCount() async{
   QuerySnapshot qs =  await Firestore.instance.collection('task_details').document(widget.user_name).collection('task_info').getDocuments();
   int t = qs.documents.length;
   if(t==0){
     t=10;
   }
   double k = (t/20)*100;
   int p = k.round();
   count = p;

  }

  final List<Color> circleColors = [
    Colors.orange[300],
    Colors.orange[500],
    Colors.deepOrange[800],
    Colors.orange[700],
    Colors.deepOrange[500],
    Colors.orange[100],
    Colors.orange[200],
    Colors.orange[400],
    Colors.orange[600],
    Colors.orange[900],
    Colors.orange[800],
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.orangeAccent[400],
  ];

  Color randomGenerator() {
    return circleColors[new Random().nextInt(circleColors.length)];
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckStatus();
    TaskCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return Future.value( false );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            colors: [
                              Colors.grey[500],
                              Colors.grey[600],
                            ]
                          ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              backgroundColor: Colors.grey[300],
                              child: Image.network(widget.img_url,
                              ),
                              radius: 30.0,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                height: MediaQuery.of(context).size.height*0.05,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: AutoSizeText(widget.user_name,style: GoogleFonts.alice(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),)),
                            Container(
                                height: MediaQuery.of(context).size.height*0.08,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: AutoSizeText(widget.role,style: GoogleFonts.alice(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 10.0,
                            animation: true,
                            percent: 0.4,
                            center: new Text(
                              "$count %",
                              style:
                              new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0,color: Colors.white),
                            ),
                            footer: new Text(
                              "Tasks remaining"
                                ,style: GoogleFonts.alice(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.white),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.orange[700],
                            backgroundColor: Colors.white,

                          ),
                        ),
                      ],
                    )
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.11,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Builder(
                              builder: (context) {
                                final GlobalKey<SlideActionState> _key = GlobalKey();
                                final dateTime = DateTime.now();
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SlideAction(
                                    key: _key,
                                    sliderButtonIconSize: MediaQuery.of(context).size.height*0.02,
                                    sliderButtonYOffset:-5,
                                    onSubmit: () {
                                      Future.delayed(
                                        Duration(seconds: 10),
                                            () => _key.currentState.reset(),
                                      );
                                      setState(() {
                                        if(check=="in") {

                                          CheckStatus();

                                            status = "out";
                                          date = DateTimeFormat.format(dateTime, format: DateTimeFormats.american) + " OUT";
                                          createState();
                                          createDate();
                                          Alert(
                                            context: context,
                                            type: AlertType.info,
                                            title: "Are you sure?",
                                            desc: "You want to check out?",
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
                                                  createDate();
                                                  createState();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                width: 60,
                                                color: Colors.orange[700],
                                              ),
                                            ],
                                          ).show();
                                        }
                                        else if(check=="out"){
                                              CheckStatus();
                                                  status = "in";
                                              date = DateTimeFormat.format(dateTime, format: DateTimeFormats.american) + " IN";
                                          createDate();
                                          createState();
                                        }
                                      });
                                    },
                                    elevation: 10,
                                    outerColor:Colors.orange[700],
                                    child: check=="in"?Shimmer.fromColors(baseColor: Colors.white,highlightColor: Colors.black,child: Text("slide to check out",style: GoogleFonts.cormorantUpright(fontSize: 25,fontWeight: FontWeight.w400,color: Colors.white),)):Shimmer.fromColors(baseColor: Colors.white,highlightColor: Colors.black,child: Text("Slide to check in",style: GoogleFonts.cormorantUpright(fontSize: 25,fontWeight: FontWeight.w400,color: Colors.white),)),
                                    height: MediaQuery.of(context).size.height*0.08,

                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (contex)=>log_history(widget.user_name)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange[700],
                          ),
                          child: Icon(Icons.history,color: Colors.white,size: 30,),
                          height: MediaQuery.of(context).size.height*0.06,
                          width: MediaQuery.of(context).size.height*0.06,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (contex)=>task_done(widget.user_name)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange[700],
                          ),
                          child: Icon(Icons.assignment_outlined,color: Colors.white,size: 30,),
                          height: MediaQuery.of(context).size.height*0.06,
                          width: MediaQuery.of(context).size.height*0.06,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (contex)=>settings(widget.user_name)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange[700],
                          ),
                          child: Icon(Icons.settings,color: Colors.white,size: 30,),
                          height: MediaQuery.of(context).size.height*0.06,
                          width: MediaQuery.of(context).size.height*0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: Divider(
                      thickness: 3,
                    )),
                    Text("TODO",style: GoogleFonts.alice(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.deepOrange,letterSpacing: 1),),
                    Expanded(child: Divider(
                      thickness: 3,
                    )),

                  ],
                ),
                Container(
                  //height: double.infinity,
                  height: MediaQuery.of(context).size.height*0.6,
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                        stream: Firestore.instance.collection("task_details").document(widget.user_name).collection("task_info").snapshots(),
                        builder: (_,snapshot){
                          if(!snapshot.hasData){
                            return Container();
                          }
                          else{
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (_,index){
                                  DocumentSnapshot info = snapshot.data.documents[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>task(info['task_name'],info['desc'],index,widget.user_name,info['date']),));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(4,0),
                                                color:  Colors.grey[300],
                                                blurRadius: 1,
                                                spreadRadius: 1
                                              ),
                                              BoxShadow(
                                                  offset: Offset(0,4),
                                                  color:  Colors.grey[300],
                                                  blurRadius: 1,
                                                  spreadRadius: 0
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        height: MediaQuery.of(context).size.height*0.11,
                                        child: Row(
                                          children: [
                                            Container(
                                                height: MediaQuery.of(context).size.height*0.11,
                                                width: MediaQuery.of(context).size.width*0.04,

                                              decoration: BoxDecoration(
                                                color: randomGenerator(),
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topLeft: Radius.circular(5)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                  height: MediaQuery.of(context).size.height*0.11,
                                                  width: MediaQuery.of(context).size.width*0.78,
                                                  child: AutoSizeText("${info['task_name']}",style: GoogleFonts.alice(fontSize: 15,color: Colors.black),)),
                                            ),
                                            Container(child: Icon(Icons.keyboard_arrow_right,size: MediaQuery.of(context).size.height*0.05,color: Colors.orange[700],))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }

                        },
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (contex)=>task_creation(widget.user_name)));
          },
          backgroundColor: Colors.orange[700],
        ),
      ),
    );
  }
}
