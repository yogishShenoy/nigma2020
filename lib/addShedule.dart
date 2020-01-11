

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nigma2020/services/CRUD.dart';
import 'package:nigma2020/warn_close.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'files/file.dart';
class AddShedule extends StatefulWidget {
  var event;
  AddShedule(this.event);
  @override
  _AddSheduleState createState() => _AddSheduleState();
}

class _AddSheduleState extends State<AddShedule> {
  DateTime _dateTime;
  var grp="",err="",errdn="",errround="",errroom="",errdate="",errfrm="",errto="",phone="";
   TextEditingController dcontrol=new TextEditingController();
   TextEditingController roomcon=new TextEditingController();
   TextEditingController data=new TextEditingController();
    TextEditingController from=new TextEditingController();
    TextEditingController to=new TextEditingController();
    @override
    void initState(){
   super.initState();
              
   PhoneFile.readFromFile().then((content){
                             setState(() {
                               phone=content; 
                              // print("i am $event");
                             });
                           });
                         
 
 }

  
  @override
 PanelController pannelControl = new PanelController();
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius=BorderRadius.only(topLeft: Radius.circular(24.0),topRight:  Radius.circular(24.0));
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
        title: Text("Add/Update Shedule"),
        centerTitle: true,
      ),
      body:SlidingUpPanel(
        controller: pannelControl,
        //backdropColor: Colors.brown,
        //backdropOpacity: 1.0,
        backdropTapClosesPanel: false,
       // backdropEnabled: false,
       color: Color.fromRGBO(88, 133, 85,1.0),
      // defaultPanelState: pop,
       isDraggable: true,
    // renderPanelSheet: false, 
    maxHeight:grp=="yes"?MediaQuery.of(context).size.height/1.17:MediaQuery.of(context).size.height/1.35,
   minHeight: MediaQuery.of(context).size.height/10, 
   parallaxEnabled: true,

        borderRadius: radius,
        panel: bodyPannel(context),
        collapsed: Container(decoration: BoxDecoration(color: Color.fromRGBO(88, 133, 85,1.0),borderRadius: radius),
        child: Center(
          child:Column(
            children:<Widget>[
          IconButton(
            iconSize: MediaQuery.of(context).size.height/14,
            color: Colors.white,
            icon: Icon(Icons.add_circle),
    onPressed: (){
      if(pannelControl.isPanelClosed()){
        err="";errdn="";errround="";errroom="";errdate="";errfrm="";errto="";
             pannelControl.open();

           }
    },
          ),
         // Text("Add Round")
            ]
          ),
  ),

        ),
        
        body: bodyPage(context),
      ),
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
               // return loading(context);
               print("no data");
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
                print("i am snap, $sindex ${sindex.length}");
                }catch(e){
                  print("u passed$e");
                  return Text("Check your Internet Connection...",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),);
                }
              return sindex.length>0?
              //Text("data found ${snapshot.value}");
           
        //child: Text("No Rounds found"),
        GridView.count(
          crossAxisCount: 3,
          scrollDirection:  Axis.vertical,
          children: List.generate(sindex.length,(index){
            return Center(
             child: Center(
               child: GestureDetector(
                 onLongPress: (){
                   crud.removeRound(widget.event, lkey[sindex[index]]);
                 },
                 onTap: (){
                   
                      // pannelControl.open();
                   
                     pannelControl.open();
                   
                   
                   setState(() {
                     dcontrol.text=lval[sindex[index]]['DATE'];
                     from.text=lval[sindex[index]]['START'];
                     to.text=lval[sindex[index]]['END'];
                     roomcon.text=lval[sindex[index]]['ROOM'];
                     //grp=
                     round=lkey[sindex[index]];
                   });
                 },
               child: Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey,width: 3.0),
                 ),
                 padding: EdgeInsets.all(25.0),
                 child: Text('${lkey[sindex[index]]}',style: TextStyle(color: Colors.white),),
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
 var round=null;

 Future check() async{

 }
 
  Widget bodyPannel(BuildContext context){
    return  ListView(
      children:<Widget>[
        ListTile(
          trailing: IconButton(
            icon: Icon(Icons.cancel),
            color: Colors.redAccent,
            iconSize: 30,
            onPressed: (){
              setState(() {
                 dcontrol.text="";
                     from.text="";
                     to.text="";
                     roomcon.text="";
                     //grp=
                     round=null;
              });
              pannelControl.close();
            },
          ),
             title: Text(widget.event,style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        RadioListTile(
      groupValue: grp,
      value: "yes",
      subtitle: Text("$errdn",style: TextStyle(color: Colors.red),),
      title: Text('Send Notification about changes'),
      onChanged: (val){
      setState(() {
        errdn="";
        grp=val;
      });
      },
    ),
    grp=="yes"?
     Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            child:
          TextField(
            onTap: (){
              setState(() {
                err="";
              });
            },
            controller:data ,
           // maxLines: data.text.length>50?(data.text.length/30).toInt():3,
           maxLines: null,
              keyboardType: TextInputType.multiline,
                              //  obscureText:hidden,
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(Icons.message),
                                 errorText: err,
                                  labelText: 'CONTENT',
                                  hintText: 'ENTER HERE....',
                                   helperStyle: TextStyle(color: Colors.red),
                                  border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid,color: Colors.white)),
                                ),
          ),
          )
    :Container(),
     RadioListTile(
       subtitle: Text("$errdn",style: TextStyle(color: Colors.red),),
       title: Text("Don't send notification"),
       value: "no",
        groupValue: grp,
         onChanged: (val){
      setState(() {
        errdn="";
        grp=val;
      });
      },
     ),
        ListTile(
          subtitle: Text("$errround",style: TextStyle(color: Colors.red),),
          leading: Text("Select Round : "),
          title:
    DropdownButton<String>(
      hint: Text("Select Round"),
      value: round,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple,),
    /*  underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
      onChanged: (String newValue) {
        setState(() {
          errround="";
          round = newValue;
        });
      },
      items: <String>['Round 1', 'Round 2', 'Round 3', 'Round 4','Round 5','Round 6','Round 7','Round 8','Round 9']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text("  $value                            ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign:TextAlign.center,),
        );
      }).toList(),
    ),
    ),
    ListTile(
      onTap: (){
        setState(() {
          errroom="";
        });
      },
      subtitle: Text("$errroom",style: TextStyle(color: Colors.red),),
      leading: Text("Place/Room No :"),
      title: TextFormField(
        onTap: (){
           setState(() {
          errroom="";
        });
        },
       controller: roomcon,
      ),
    ),
    ListTile(
      onTap: (){
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2021),
        ).then((date){
          setState(() {
            errdate="";
            print(date.toString());
            dcontrol.text="${date.day}-${date.month}-${date.year}";
          });
        });
      },
      subtitle: Text("$errdate",style: TextStyle(color: Colors.red),),
      leading: Text("Event date :"),
      title: TextFormField(
         enabled: false,
         controller:dcontrol,
       // initialValue: _dateTime.toString()!=null&&_dateTime.toString()!=""?_dateTime.toString():"Select date",
        decoration: InputDecoration(
          
        ),

      ),
    ),
    ListTile(
      onTap: (){

        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((time){
          setState(() {
            errfrm="";
            print("${time.toString()}");
            timecal(time,"f");
            // from.text="${time.hour}:${time.minute}";

           
          });
        });
      },
      subtitle: Text("$errfrm",style: TextStyle(color: Colors.red),),
      leading: Text("Event Starts at :"),
      title: TextFormField(
         enabled: false,
         controller:from,
       // initialValue: _dateTime.toString()!=null&&_dateTime.toString()!=""?_dateTime.toString():"Select date",
        decoration: InputDecoration(
          
        ),

      ),
    ),
    ListTile(
      onTap: (){
        setState(() {
          errto="";
        });
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((time){
          setState(() {
            print("${time.toString()}");
           timecal(time,"t");
          // to.text="${time.hour}:${time.minute}";
          });
        });
      },
      leading: Text("Event Ends at :"),
      subtitle: Text("$errto",style: TextStyle(color: Colors.red),),
      title: TextFormField(
         enabled: false,
         controller:to,
       // initialValue: _dateTime.toString()!=null&&_dateTime.toString()!=""?_dateTime.toString():"Select date",
        decoration: InputDecoration(
          
        ),

      ),
    ),
    Text(""),
    
   Center(
     child: CircleAvatar(
      maxRadius: MediaQuery.of(context).size.width/13,
       backgroundColor: Colors.blue,
       child:
     IconButton(icon: Icon(Icons.send),color: Colors.white,onPressed: (){
       if(grp=="yes"){
         if(data.text==""){
           setState(() {
             err="*enter the notification";
           });
         }
       }else if(grp=="no"){
         setState(() {
           data.text="";
         });
         
       }else if(grp==""||grp==null){
         setState(() {
           errdn="*required";
         });
         
       }else{
         setState(() {
           errdn="";
         });
       }
       if(round==null||round==""){
         setState(() {
           errround="* Select the Round";
         });
       }else{
         setState(() {
           errround="";
         });
       }
       if(roomcon.text==""||roomcon.text==null){
         setState(() {
           errroom="* Enter the Room No.";
         });
       }else{
         setState(() {
           errroom="";
         });
       }
       if(dcontrol.text==""||dcontrol.text==null){
         setState(() {
           errdate="* Enter the date";
         });
       }else{
         setState(() {
           errdate="";
         });
       }
       if(from.text==""||from.text==null){
         setState(() {
           errfrm="* Enter the Starting time";
         });
       }else{
         setState(() {
           errfrm="";
         });
       }
       if(to.text==""||to.text==null){
         setState(() {
           errto="* Enter event ending time";
         });
       }else{
         setState(() {
           errto="";
         });
       }
      if(grp==""||round==null||roomcon.text==""||roomcon.text==null||dcontrol.text==""||dcontrol.text==null||from.text==""||from.text==null||to.text==""||to.text==null)
        {
           print("not filled");
        }else{
          
           upload();
           
        }



      
     },iconSize: MediaQuery.of(context).size.width/14,),
     ),
   )
     
      
    ]);
  }
  void timecal(TimeOfDay time,var z){
    var apm="",apm1="";int t=0, t1=0;
    if(time.hour>12&&time.hour<23){
       if(z=="f"){
             
               apm="PM";
               t=int.parse(time.hour.toString())-12;
               t=0+t;
             
            }else{
              
               apm1="PM";
               t1=int.parse(time.hour.toString())-12;
               t1=0+t1;
            
              
            }
             
            }else{
              if(z=="f"){
               t=time.hour;
               apm="AM";
           
              }else{
               t1=time.hour;
               apm1="AM";
             
              }
            }
            if(z=="f"){
             setState(() {
                from.text="${t.toString()}:${time.minute}:$apm";
             });
            }else{
               setState(() {
                to.text="${t1.toString()}:${time.minute}:$apm1 ";
             });
            }
           
  }
  crudMethods crud=new crudMethods();
  upload(){
     Map<String,dynamic> packet={
                   "DATE" : dcontrol.text,
                   "ROOM":roomcon.text,
                   "START":from.text,
                   "END":to.text,
                 };
                 if(grp=="yes"&&data.text!=""){
                    Map<String,dynamic>packet1={
        "head":widget.event,
        "body":data.text.toString(),
         "PHONE":phone.toString(),
         "TIME":DateTime.now().toString(),
         "TYPE":"ROUND",
      };
           crud.sendNotification(packet1);
                 }
     
    crud.addRound(widget.event,round,packet);
  
    err_spin("Uploaded sucessfully...");
    setState(() {
                 dcontrol.text="";
                     from.text="";
                     to.text="";
                     roomcon.text="";
                     //grp=
                     round=null;
              });
              pannelControl.close();

  }
  Future<bool> err_spin(String dis) {
     return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog("$dis");
      }
    
    );
}
}