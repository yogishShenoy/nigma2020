import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class ShowResults extends StatefulWidget {
  var event,notiRound;
  ShowResults(this.event,[this.notiRound]);
  @override
  _ShowResultsState createState() => _ShowResultsState();
}

class _ShowResultsState extends State<ShowResults> {
  var round="";
   var bools = new List();
   var bools1 = new List();
  PanelController pannelControl = new PanelController();
   BorderRadiusGeometry radius=BorderRadius.only(topLeft: Radius.circular(24.0),topRight:  Radius.circular(24.0)); 
   @override
   void initState(){
     bools.clear();
     if(widget.event!=null&&widget.notiRound!=null){
      print("${widget.event.toString().toUpperCase()}/${widget.notiRound}/RESULT");
       FirebaseDatabase.instance.reference().child("${widget.event.toString().toUpperCase()}/${widget.notiRound}/RESULT").once().then((val){
         Map a=val.value;
         Iterable b=a.values;
         setState(() {
            bools1=b.toList();
         });
        
         round=widget.notiRound;
          print("${widget.event.toString().toUpperCase()}/${widget.notiRound}/ $bools1");
       
        
       });
     // pannelControl.open();
     }
     super.initState();
   }
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
       defaultPanelState: widget.notiRound!=null?PanelState.OPEN:PanelState.CLOSED,
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
               //  print("maps $s");
                 lkey.sort();
                for(int i=0;i<ikey.length;i++){
                  bool r=lkey[i].toString().contains('Round');
                  if(r){
                  
                      sindex.add(i);
                    
                    
                  }
                }
           //     print("i am snap, $sindex ${sindex.length}");
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
                   
                 },
               child: Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey,width: 3.0),
                 ),
                 padding: EdgeInsets.all(MediaQuery.of(context).size.width/28),
               child:  OutlineButton(
                 onPressed: (){
                       bools1.clear();
                   bools.clear();
                   print("aa ${lkey[sindex[index]]}");
                  FirebaseDatabase.instance.reference().child("${widget.event.toString().toUpperCase()}/${lkey[sindex[index]]}").once().then((val){
                   
                   try{ 

                  Map ma=val.value;
                  print("mm ${ma}");
                 if(ma.containsKey("RESULT")){
                  print("maaa $ma");
                  Iterable it=ma['RESULT'].values;
                  setState(() {
                    bools=it.toList();
                  });
                  
                 }else{
                   bools.clear();
                  
                 }
                   }catch(e){
                     print(e);
                   }
                    });
                   setState(() {
                     bools.clear();
                     round=lkey[sindex[index]];
                   });
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ClgList(widget.event,lkey[sindex[index]])));
                       pannelControl.open();
                      // bodyPannel(context,lkey[sindex[index]]);
                   
                     //pannelControl.open();
                   
                 
                 },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 3, //width of the border
          ),   
                 child: Text('${lkey[sindex[index]]}',style: TextStyle(color: Colors.white),),
               ),
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
             subtitle: Text(round==null||round==""?"${widget.notiRound}":"$round"),
        ),
        Expanded(
          child: bools1.length==0&&bools.length==0?Text("No result"):
          ListView.builder(
            itemCount:bools1.length>0?bools1.length:bools.length,
            itemBuilder: (context,index){
              return Card(
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                
                child:Container(
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child:
                 Text(bools1.length>0?"${bools1[index]}":bools.length==0?"No result":"${bools[index]}",textAlign: TextAlign.center,),
                )
              );
            },
          ),
        )
      ]
    );
  }
}