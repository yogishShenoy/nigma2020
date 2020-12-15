import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:nigma2020/files/file.dart';
import 'package:nigma2020/services/CRUD.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../warn_close.dart';
class ClgList extends StatefulWidget {
  var event,round;
  ClgList(this.event,this.round);
  @override
  _ClgListState createState() => _ClgListState();
}

class _ClgListState extends State<ClgList> {
  PanelController pannelControl = new PanelController();
  TextEditingController noti=new TextEditingController();
  var err="",err1="",phone="0";
  var ds;
  BorderRadiusGeometry radius=BorderRadius.only(topLeft: Radius.circular(24.0),topRight:  Radius.circular(24.0));
  @override
    void initState(){
   super.initState();
    FirebaseDatabase.instance.reference().child("${widget.event}/${widget.round}/RESULT").once().then((val){
     
     Map ma=val.value;
     Iterable it=ma.values;
     bools=it.toList();

   });
   
   PhoneFile.readFromFile().then((content){
                             setState(() {
                               phone=content; 
                              
                             });
                           });
                         
 
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.round),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
      ),
         body:SlidingUpPanel(
       controller: pannelControl,
       backdropTapClosesPanel: false,
       color: Color.fromRGBO(88, 133, 85,1.0),
       isDraggable: false,
        maxHeight:MediaQuery.of(context).size.height/1.1,
         minHeight: MediaQuery.of(context).size.height/10, 
         parallaxEnabled: true,
         borderRadius: radius,
        panel: bodyPannel(context),
        collapsed: Container(decoration: BoxDecoration(color: Color.fromRGBO(88, 133, 85,1.0),borderRadius: radius),
        child: Center(
          child:Column(
            children:<Widget>[
        
          Padding(padding: EdgeInsets.only(top: 10),),
          RaisedButton.icon(
            elevation: 100,
            icon: Icon(Icons.done_outline,color: Colors.green.shade100,),
            label: Text("CONFIRM"),
            onPressed: (){
              if(bools.length>0){
                 pannelControl.open();
              }
            },
          )
         
            ]
          ),
  ),

        ),
        
        body: bodyPage(context),
      ),
    );
  
  }
   Widget bodyPannel(BuildContext context){
    return  Column(
      children:<Widget>[
        ListTile(
          trailing: IconButton(
            icon: Icon(Icons.cancel),
            color: Colors.redAccent,
            iconSize: 30,
            onPressed: (){
              setState(() {
                noti.text="";
              });
              pannelControl.close();
            },
          ),
             title: Text("${widget.event} : ${widget.round}",style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text("Count of Qualified Colleges : ${bools.length}"),
        ),
        Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            child:
          TextField(
            onTap: (){
              setState(() {
               err="";
              });
            },
            controller:noti,
           
           maxLines: null,
              keyboardType: TextInputType.multiline,
                              //  obscureText:hidden,
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(Icons.message),
                                  errorText: err,
                                  labelText: 'NOTIFICATION',
                                  hintText: 'ENTER HERE....',
                                   helperStyle: TextStyle(color: Colors.red),
                                  border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid,color: Colors.white)),
                                ),
          ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 13),),
        Expanded(
          child: bools.length<=0?Center(child: Text(err!=""?err:"* Select Qualified College",style: TextStyle(color: Colors.red),),):
          ListView.builder(
            itemCount: bools.length,
            itemBuilder: (context,index){
              return Card(
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                
                child:Container(
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child:
                 Text("${bools[index]}",textAlign: TextAlign.center,),
                )
              );
            },
          ),
        ),
        
        RaisedButton.icon(
          icon: Icon(Icons.send),
          label: Text("Send"),
          onPressed: (){
            if(bools.length<=0){
              setState(() {
                err1="* Select Qualified College";
              });
            }
            if(noti.text==""){
              setState(() {
                err="* Enter Notification";
              });
            }
            if(bools.length>0&&noti.text!=""){
              upload();
            }


          },
        ),
        Padding(padding: EdgeInsets.only(bottom: 17),)
      ]
    );
  }

  upload(){
    Map<String,dynamic>packet=new Map();
    for(int i=0;i<bools.length;i++){
     
      packet["CLG_$i"]=bools[i];
        //packet.putIfAbsent("CLG_$i",()=> "${bools[i]}");
    }
    Map<String,dynamic>packet1={
        "head":widget.event,
        "body":noti.text.toString(),
         "PHONE":phone.toString(),
         "TIME":DateTime.now().toString(),
         "ROUND":widget.round,
         "TYPE":"RESULT",
      };
    
    crud.sendNotification(packet1);
    crud.addResult(widget.event, widget.round, packet);
    setState(() {
      noti.text="";
    });
     pannelControl.close();
    err_spin("Uploaded sucessfully...");
    
  }
     Future<bool> err_spin(String dis) {
     return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog("$dis");
      }
    
    );
}
  crudMethods crud=new crudMethods();
  var bools = new List(); 
   Widget bodyPage(BuildContext context){
   
    var getclg = FirebaseDatabase.instance.reference().child("COLLEGES");
    return Container(
      child:  Center(
        child:StreamBuilder(
          stream: getclg.onValue,
          builder: (context,snap)  {
              if(snap==null){
               // return loading(context);
              
               return Text("No college");
              }else{
                List lval,lkey;
                try{
                DataSnapshot snapshot = snap.data.snapshot;
                Map s=snapshot.value;
                Iterable ikey=s.keys;
                Iterable ival=s.values;
                 lkey=ikey.toList();
                 lval=ival.toList();
              
                
            
                }catch(e){
                  
                  return Text("Check your Internet Connection...",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),);
                }
              return lkey.length>0?
              
           
      
       ListView.builder(
           itemCount: lkey.length,
          itemBuilder:(context,index){
           return Column(
             children:<Widget>[
               Card(
                 elevation: 100,
                 //clipBehavior: Clip.hardEdge,
                 margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                 child:
           ListTile(
             trailing: Checkbox(
               activeColor: Colors.green,
               value: bools.contains(lval[index]["CODE"]),
               onChanged: (val){
                   setState(() {
          if(val){
            bools.add(lval[index]["CODE"]);
           
          }else{
           bools.remove(lval[index]["CODE"]);
           
          }
        });
               },
             ),
             leading: Icon(Icons.people),
             title: Text("${lval[index]["CODE"]}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
             subtitle: Text("${lval[index]["NAME"]}",style: TextStyle(color: Colors.blue,),textAlign: TextAlign.center,),
           ),
               ),
        
             ]
           );
           
           
          } ,
        ):Center(
          child:
          Text("No Rounds Added")
        );
              }
          })
      )
    );
 
  }
}
