import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class task extends StatefulWidget {
  String name;
  String desc;
  int index;
  String user_name;
  String date;
  task(this.name,this.desc,this.index,this.user_name,this.date);
  @override
  _taskState createState() => _taskState();
}

class _taskState extends State<task> {

  delete(index) async{
    CollectionReference collectionReference = Firestore.instance.collection('task_details').document(widget.user_name).collection('task_info');
    QuerySnapshot querySnapshot= await collectionReference.getDocuments();
    querySnapshot.documents[index].reference.delete();
  }

  createDate(){
    CollectionReference collectionReference = Firestore.instance.collection('task_done').document(widget.user_name).collection("task_info");
    Map<String,dynamic> eventinfo ={
      "task_name":widget.name,
      "desc":widget.desc,
    };
    collectionReference.document(widget.name).setData(eventinfo);
  }

  Function delAdd(){
    delete(widget.index);
    createDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task details",style: GoogleFonts.alice(fontSize: 20,fontWeight: FontWeight.w400),),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(4,0),
                        color: Colors.grey[300],
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
                  border: Border.all(width: 2,color: Colors.black12)
                  ),
                height: MediaQuery.of(context).size.height*0.65,
                width: MediaQuery.of(context).size.width*1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height*0.08,
                          width: MediaQuery.of(context).size.width*1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Title :",style: GoogleFonts.alice(fontSize: 18),),
                              Text("\t ${widget.name}",style: GoogleFonts.alice(fontSize: 15),),

                            ],
                          )),
                      Container(
                          height: MediaQuery.of(context).size.height*0.5,
                          width: MediaQuery.of(context).size.width*1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Text("Description :",style: GoogleFonts.alice(fontSize: 18),),
                              widget.desc!=null?Text("\t ${widget.desc}",style: GoogleFonts.alice(fontSize: 15),):Text("\t No description",style: GoogleFonts.alice(fontSize: 15),),

                            ],
                          )),
                      widget.date!=null?Text("Deadline ${widget.date}"):Container(),
                    ],
                  ),
                ),

              ),
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               IconButton(icon: Icon(Icons.delete_forever_outlined,color: Colors.red,size: 30,), onPressed: (){
                 Alert(
                   context: context,
                   type: AlertType.info,
                   title: "Are you sure?",
                   desc: "you want to delete this task?",
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
                         delAdd();
                         Navigator.pop(context);
                         Navigator.pop(context);
                       },
                       width: 60,
                       color: Colors.orange[700],
                     ),
                   ],
                 ).show();
               },),
               Padding(
                 padding: const EdgeInsets.only(right: 10,top: 10),
                 child: RaisedButton(onPressed: (){
                   Alert(
                     context: context,
                     type: AlertType.info,
                     title: "Are you sure?",
                     desc: "Have you completed the task?",
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
                           delete(widget.index);
                           Navigator.pop(context);
                           Navigator.pop(context);
                         },
                         width: 60,
                         color: Colors.orange[700],
                       ),
                     ],
                   ).show();
                 },
                   child: Text("Make as Done",style: GoogleFonts.alice(color: Colors.white),),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                   color: Colors.orange[700],
                 ),
               ),
             ],
           )
          ],
        ),
      ),
    );
  }
}
