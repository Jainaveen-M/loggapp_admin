import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';

class task_done extends StatefulWidget {
  String name;
  task_done(this.name);
  @override
  _task_doneState createState() => _task_doneState();
}

class _task_doneState extends State<task_done> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks done",style: GoogleFonts.alice(fontSize: 20,fontWeight: FontWeight.w400),),
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
              stream:Firestore.instance.collection('task_done').document(widget.name).collection("task_info").snapshots(),
              builder: (context,snapshot){
                if (!snapshot.hasData) {
                  return Container( );
                }
                else{
                  return ListView.builder(
                    itemCount:snapshot.data.documents.length,
                    itemBuilder: (context,index){
                      DocumentSnapshot info = snapshot.data.documents[index];
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.orange[200],
                          borderRadius: BorderRadius.circular(10.0),

                        ),
                        height: MediaQuery.of(context).size.height*0.25,
                        width: MediaQuery.of(context).size.width*1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                  height: MediaQuery.of(context).size.height*0.06,
                                  width: MediaQuery.of(context).size.width*0.95,
                                  child: AutoSizeText("Title :  ${info['task_name']}")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                  height: MediaQuery.of(context).size.height*0.17,
                                  width: MediaQuery.of(context).size.width*0.95,
                                  child: AutoSizeText("\nDescription : ${info['desc']}")),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                }
              },
            ),
          ),
        ],
      )
    );

  }
}
