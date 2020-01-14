import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:nigma2020/services/CRUD.dart';
import 'package:nigma2020/warn_close.dart';

import 'files/file.dart';

class SendNotification extends StatefulWidget {
  String event="";
  SendNotification(this.event);
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  var phone="";
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
  TextEditingController data=new TextEditingController();
  var err="";
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
     title: Text("Send Notification"),
     centerTitle: true,
     backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
     elevation: 0,
    ),
    body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    
    return SingleChildScrollView(
      //padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          //const SizedBox(height: 20.0),
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
          ),
          Padding(padding: EdgeInsets.only(top: 30),),
    RaisedButton(
      child: Text("Send"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: () {
        if(data.text==""){
          setState(() {
            err="* Please enter the message";
          });
        }else{
          upload();
        }
      },
    ),
        ],
      ),
    );
  }
crudMethods crud=new crudMethods();
  upload()async{
     Map<String,dynamic>packet1={
        "head":widget.event,
        "body":data.text.toString(),
         "PHONE":phone.toString(),
         "TIME":DateTime.now().toString(),
         "TYPE":"NORMAL",
      };
      crud.sendNotification(packet1);
       err_spin("Uploaded sucessfully...");
       data.text="";

  }
  Future<bool> err_spin(String dis) {
     return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog("$dis");
      }
    
    );
}

  Widget _buildHeader() {
    return Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(88, 133, 85,1.0),
              ),
              height: 160,
            ),
          ),
          Center(
            child:
          Container(
            padding: EdgeInsets.only(top: 10,),
            child:  Image.asset("images/n1.gif",height: 100,),
          )
          ),
         
          //Padding(padding: EdgeInsets.only(top: 70,left: 20),),
          //Text("          ${widget.event}",textAlign: TextAlign.left,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
    
    ]);
  }

}