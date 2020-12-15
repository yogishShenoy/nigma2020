import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nigma2020/services/CRUD.dart';
import 'package:nigma2020/warn_close.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class AddClg extends StatefulWidget {
  var event;
  AddClg(this.event);
  @override
  _AddClgState createState() => _AddClgState();
}

class _AddClgState extends State<AddClg> {
  PanelController pannelControl = new PanelController();
  TextEditingController name=new TextEditingController();
  TextEditingController code=new TextEditingController();
  var ername="",ercode="";
   BorderRadiusGeometry radius=BorderRadius.only(topLeft: Radius.circular(24.0),topRight:  Radius.circular(24.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD COLLEGE"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
      ),
     body: SlidingUpPanel(
       controller: pannelControl,
       backdropTapClosesPanel: false,
       color: Color.fromRGBO(88, 133, 85,1.0),
       isDraggable: false,
        maxHeight:MediaQuery.of(context).size.height/2.8,
         minHeight: MediaQuery.of(context).size.height/10, 
         parallaxEnabled: true,
         borderRadius: radius,
        panel: bodyPannel(context),
        collapsed: Container(decoration: BoxDecoration(color: Color.fromRGBO(88, 133, 85,1.0),borderRadius: radius),
        child: Center(
          child:Column(
            children:<Widget>[
          IconButton(
            iconSize: MediaQuery.of(context).size.height/15,
            color: Colors.white,
            icon: Icon(Icons.group_add),
    onPressed: (){
      if(pannelControl.isPanelClosed()){
      
             pannelControl.open();

           }
    },
          ),
         
            ]
          ),
  ),

        ),
        
        body: bodyPage(context),
      ),
    );
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
                 code.text="";
                 name.text="";
                 ername="";
                 ercode="";
              });
              pannelControl.close();
            },
          ),
             title: Text(widget.event,style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        ListTile(
          onTap: (){
            setState(() {
              ername="";
            });
          },
          title: TextFormField(
            onTap: (){
            setState(() {
              ername="";
            });
          },
           controller: name,
           decoration: InputDecoration(
             hintText: "Actual college name",
              errorText: ername,
              errorStyle: TextStyle(color: Colors.red)
           ),
          ),
          leading: Text("College name :"),
        ),
        ListTile(
          onTap: (){
            setState(() {
              ercode="";
            });
          },
          title: TextFormField(
            onTap: (){
           setState(() {
              ercode="";
            });
            },
           controller: code,
           decoration: InputDecoration(
             hintText: "College code",
              errorText: ercode,
              errorStyle: TextStyle(color: Colors.red)
           ),
          ),
          leading: Text("College code :"),
        ),
        Padding(padding: EdgeInsets.only(top: 10),),
        Center(
          child: RaisedButton(
            color: Colors.blue,
            onPressed: (){
              if(name.text==""){
                 setState(() {
                   ername="* Enter the college name";
                 });
              }else if(code.text==""){
                setState(() {
                  ercode="* Enter the college code";
                });
              }else{
                upload();
              }
            },
            child:Text("Add College"),
          ),
        )
      ]
    );
  }
  crudMethods crud=new crudMethods();
  upload()async{
    Map<String,dynamic> packet={
      "NAME":name.text,
      "CODE":code.text
    };
    crud.addColleges(packet);
    setState(() {
      code.text="";
      name.text="";
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
              Column(
                children:<Widget>[
              Container(
                margin: EdgeInsets.only(top: 10,bottom: 10),
                child: Text("TOTAL COLLEGES REGISTERED : ${lkey.length}",style: TextStyle(color: Colors.green),),

              ),
           
        //child: Text("No Rounds found"),
        new Expanded(
          child:
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
             trailing: IconButton(icon: Icon(Icons.delete_forever),color: Colors.red,onPressed: (){
               crud.removeRound("COLLEGES", lval[index]['CODE']);
             },),
             leading: Icon(Icons.people),
             title: Text("${lval[index]["CODE"]}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
             subtitle: Text("${lval[index]["NAME"]}",style: TextStyle(color: Colors.blue,),textAlign: TextAlign.center,),
           ),
               ),
         
             ]
           );
           
           
          } ,
       ) )]):Center(
          child:
          Text("No Rounds Added")
        );
              }
          })
      )
    );
 
  }
}