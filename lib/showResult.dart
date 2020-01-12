import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class ShowResults extends StatefulWidget {
  var event;
  ShowResults(this.event);
  @override
  _ShowResultsState createState() => _ShowResultsState();
}

class _ShowResultsState extends State<ShowResults> {
  var round="";
  PanelController pannelControl = new PanelController();
   BorderRadiusGeometry radius=BorderRadius.only(topLeft: Radius.circular(24.0),topRight:  Radius.circular(24.0)); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RESULTS"),
        backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
        centerTitle: true,
      ),
     body: SlidingUpPanel(
       controller: pannelControl,
       backdropTapClosesPanel: false,
       color: Color.fromRGBO(88, 133, 85,1.0),
       isDraggable: false,
        maxHeight:MediaQuery.of(context).size.height/1.3,
         minHeight: MediaQuery.of(context).size.height/10, 
         parallaxEnabled: true,
         borderRadius: radius,
        panel: bodyPannel(context),
        collapsed: Container(decoration: BoxDecoration(color: Color.fromRGBO(88, 133, 85,1.0),borderRadius: radius),
        child: Center(
          child:Column(
            children:<Widget>[
             Padding(padding: EdgeInsets.only(top: 20),),
               Text("ALL THE BEST")
            ]
          ),
  ),

        ),
        
        body: bodyPage(context),
      ),
    );
  
  }
  var bools = new List();
  Widget bodyPage(BuildContext context){
    var getRound = FirebaseDatabase.instance.reference().child(widget.event.toString().toUpperCase());
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
                  return Center(
                    child:
                    Column(
                      children:<Widget>[
                        Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.6)),
                  Text("Turn on Internet Connection...",style: TextStyle(color: Colors.red,fontSize: 20),),
                  IconButton(color: Colors.lime,iconSize:40,icon: Icon(Icons.refresh),onPressed: (){
                    setState(() {
                      
                    });
                  },)
                      ])
                  );
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
                //   crud.removeRound(widget.event, lkey[sindex[index]]);
                 },
                 onTap: (){
                   bools.clear();
                                       FirebaseDatabase.instance.reference().child("${widget.event.toString().toUpperCase()}/${lkey[sindex[index]]}/RESULT").once().then((val){
                   print("mm ${val.key}");
                   try{
                  Map ma=val.value;
                  print("maaa $ma");
                  Iterable it=ma.values;
                  bools=it.toList();
                   }catch(e){
                     
                   }
                    });
                   setState(() {
                     round=lkey[sindex[index]];
                   });
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ClgList(widget.event,lkey[sindex[index]])));
                       pannelControl.open();
                      // bodyPannel(context,lkey[sindex[index]]);
                   
                     //pannelControl.open();
                   
                   
                   setState(() {
                   //  dcontrol.text=lval[sindex[index]]['DATE'];
                    /// from.text=lval[sindex[index]]['START'];
                   //  to.text=lval[sindex[index]]['END'];
                   //  roomcon.text=lval[sindex[index]]['ROOM'];
                     //grp=
                   //  round=lkey[sindex[index]];
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
          Text("ROUNDS NOT FOUND",style: TextStyle(color: Colors.red),)
        );
           }
          }
          )
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
                
              });
              pannelControl.close();
            },
          ),
             title: Text(widget.event,style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text("$round"),
        ),
        Expanded(
          child: bools.length==0?Text("No result"):
          ListView.builder(
            itemCount: bools.length,
            itemBuilder: (context,index){
              return Card(
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                
                child:Container(
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child:
                 Text(bools.length==0?"No result":"${bools[index]}",textAlign: TextAlign.center,),
                )
              );
            },
          ),
        )
      ]
    );
  }
}