import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_log_admin/task_details.dart';

class task_creation extends StatefulWidget {
  String user_name;
  task_creation(this.user_name);
  @override
  _task_creationState createState() => _task_creationState();
}

class _task_creationState extends State<task_creation> {


  DateTime selectedDate = DateTime.now();

  Future<void>  chooseDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String task_name,desc,date;
  createDate(){
    Map<String,dynamic> eventinfo ={
      "task_name":task_name,
      "desc":desc,
      "date":DateTimeFormat.format(selectedDate, format: 'D, M j').toString(),
    };
    Firestore.instance.collection('task_details').document(widget.user_name).collection("task_info").document(task_name).setData(eventinfo);
  }

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task creation",style: GoogleFonts.alice(fontSize: 20,fontWeight: FontWeight.w400),),
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
                      labelText: "Task title",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange[700],width: 2.0),
                      ),
                    ),
                    onChanged: (String title){
                      task_name=title;

                    },
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter the task title';
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
                      labelText: "Description",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange[700],width: 2.0),
                      ),
                    ),
                    onChanged: (String title){
                      desc=title;

                    },

                   /* validator: (value){
                      if(value.isEmpty){
                        return 'Enter the task description';
                      }
                      else{
                        return null;
                      }
                    }*/
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateTimeFormat.format(selectedDate, format: 'D, M j').toString()),
                    RaisedButton(onPressed: (){
                      chooseDate(context);
                    },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.grey[600],
                      child: Text("Choose date",style: GoogleFonts.alice(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white)),
                    ),
                  ],
                ),
              ),
              RaisedButton(onPressed: (){
                if(_key.currentState.validate()){
                  createDate();
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
