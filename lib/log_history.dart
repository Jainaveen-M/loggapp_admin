import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class log_history extends StatefulWidget {
  String name;
  log_history(this.name);
  @override
  _log_historyState createState() => _log_historyState();
}

class _log_historyState extends State<log_history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("log history",style: GoogleFonts.alice(fontSize: 20,fontWeight: FontWeight.w400),),
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
              stream:Firestore.instance.collection('log_details').document(widget.name).collection("log_info").snapshots(),
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
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text("${info['date']}"),
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
