import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nigma2020/CanHome/headResult/clgList.dart';
class AddResult extends StatefulWidget {
  var event;
  AddResult(this.event);
  @override
  _AddResultState createState() => _AddResultState();
}

class _AddResultState extends State<AddResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UPLOAD RESULT"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
      ),
      body:bodyPage(context) ,

    );
  }
   Widget bodyPage(BuildContext context){
    var getRound = FirebaseDatabase.instance.reference().child(widget.event);
    return Container(
      child:  Center(
        child:StreamBuilder(
          stream: getRound.onValue,
          builder: (context,snap)  {
              if(snap==null){
               
              
               return Text("No Rounds");
              }else{
                List sindex,lval,lkey;
                try{
                DataSnapshot snapshot = snap.data.snapshot;
                Map s=snapshot.value;
                Iterable ikey=s.keys;
                Iterable ival=s.values;
                 lkey=ikey.toList();
                 lval=ival.toList();
                 sindex=new List();
                for(int i=0;i<ikey.length;i++){
                  bool r=lkey[i].toString().contains('Round');
                  if(r){
                    sindex.add(i);
                  }
                 
                }
               
                }catch(e){
                 
                  return Text("Check your Internet Connection...",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),);
                }
              return sindex.length>0?
        GridView.count(
          crossAxisCount: 3,
          scrollDirection:  Axis.vertical,
          children: List.generate(sindex.length,(index){
            return Center(
             child: Center(
               child: GestureDetector(
                 onLongPress: (){

                 },
                 onTap: (){
                   
                   setState(() {
                   });
                 },
               child: Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey,width: 3.0),
                 ),
                 padding: EdgeInsets.all(MediaQuery.of(context).size.width/28),
               child:  OutlineButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 3, //width of the border
          ),   
          onPressed:(){  Navigator.push(context, MaterialPageRoute(builder: (context)=>ClgList(widget.event,lkey[sindex[index]])));},
                 child: Text('${lkey[sindex[index]]}',style: TextStyle(color: Colors.white),),
                  
                   
                  
               ),
               ),
             ),
             )
            
            );
          }),
        ):Center(
          child:
          Text("No Rounds Added")
        );
           }
          }
          )
      ),
    );
  }
}