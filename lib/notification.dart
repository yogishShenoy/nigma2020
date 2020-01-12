 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

 class Notifications extends StatefulWidget {
   @override
   _NotificationsState createState() => _NotificationsState();
 }
 
 class _NotificationsState extends State<Notifications> {
    //var gen;
     void initState(){
   super.initState();
   /*setState(()  {
     try{
      gen=  Firestore.instance.collection('notifications').snapshots();
      print("${gen}");
     }catch(e){
       print("hey e");
     }
   });*/
     }
     
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Notification"),
         centerTitle: true,
         backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
         elevation: 0,
       ),
       body:
       Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color:Color.fromRGBO(88, 133, 85,1.0),
              ),
              height: 200,
            ),
          ),
        //  gen!=null?
       //build(context):Text("no data"),
      new StreamBuilder(
    stream: Firestore.instance.collection("notifications").orderBy("TIME",descending: true).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Text(
          'No Data...',
        );
      } else { 
         List<DocumentSnapshot> items = snapshot.data.documents;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount:items.length,
            itemBuilder: (context, index) {
              return 
              buildItem(context, snapshot.data.documents[index]);
            },
          );
      }
    }
      ),
        ]),
        //build(context),
     );
    
   }
   
    Widget buildItem(BuildContext context, DocumentSnapshot document) {
  //  Question question = questions[index];
  //  bool correct = question.correctAnswer == answers[index];
  DateTime date;
  if(document['TIME']!=null){
  date=DateTime.parse(document['TIME']);
  }else{
    date=DateTime.now();
  }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${document['head']}", style: TextStyle(
              color: Colors.red.shade500,
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            ),),
            SizedBox(height: 5.0),
            Text("${document['body']}", style: TextStyle(
              color:  Colors.white ,
              fontSize: 15.0,
              fontWeight: FontWeight.bold
            ),),
           // SizedBox(height: 5.0),
            
             Container(
               alignment: Alignment.bottomRight,
               child:Column(
                 children:<Widget>[
               Text(" Date : ${date.day}-${date.month}-${date.year}", style: TextStyle(
              color:  Colors.blue ,
              fontSize: 15.0,
              fontWeight: FontWeight.bold
            ),),
            Text(" Time : ${date.hour}:${date.minute}", style: TextStyle(
              color:  Colors.blue ,
              fontSize: 15.0,
              fontWeight: FontWeight.bold
            ),),
          ]),
             )
             /* Text.rich(TextSpan(
              children: [
                TextSpan(text: "Answer: "),
                TextSpan(text:question.correctAnswer , style: TextStyle(
                  fontWeight: FontWeight.w500
                ))
              ]
            ),style: TextStyle(
              fontSize: 16.0
            ),)*/
          ],
        ),
      ),
    );
  }
 }