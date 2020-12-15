import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nigma2020/CanHome/home.dart';
import 'package:nigma2020/Loading_dia.dart';

import 'files/file.dart';

class BeautifulAlertDialog extends StatefulWidget {
  var msg,delid,sub_name="";
  List vid;
  BeautifulAlertDialog(this.msg,[this.vid]){

  }
   BeautifulAlertDialog.delsub(this.msg,this.delid,this.sub_name);

  @override
  _BeautifulAlertDialogState createState() => _BeautifulAlertDialogState();
}

class _BeautifulAlertDialogState extends State<BeautifulAlertDialog> {
  TextEditingController phone=new TextEditingController();
  DatabaseReference _databaseReference =FirebaseDatabase.instance.reference();
  final FirebaseMessaging _messaging = FirebaseMessaging();
  var erph="";
  bool spin_loader=false,spin=false;
  var verificationId,vevent,vnumber;
  @override
  void initState(){
   super.initState();
    spin=false;
   if(widget.vid!=null){
     verificationId=widget.vid[0];
     vevent=widget.vid[1];
     vnumber=widget.vid[2];
     
   }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(75),
              bottomLeft: Radius.circular(75),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10)
            )
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              spin?CircleAvatar(radius: 40, backgroundColor: Colors.grey.shade300, child:Image.asset("images/spin.gif", width: 80),):
              CircleAvatar(radius: widget.msg=="login"?40:55, backgroundColor: Colors.grey.shade300, child:widget.msg=="Plaese check your internet connection"?Icon(Icons.signal_cellular_connected_no_internet_4_bar,color: Colors.red.shade900,size: 50,):Image.asset(widget.msg=="login"?"images/all/manager1.png":widget.msg=="Login Sucessfull..."||widget.msg=="Uploaded sucessfully..."?"images/done.gif":widget.msg=="otp"?"images/mobile.png":'images/warn.png', width: widget.msg=="login"?50:60,height:60),),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   
                    Text(widget.msg=="otp"?"PASSWORD":widget.msg=="login"?"EVENT HEAD LOGIN":widget.msg=="Login Sucessfull..."||widget.msg=="Uploaded sucessfully..."?"":"Alert !", style: TextStyle(color:widget.msg=="login"?Colors.green: Colors.red,fontWeight: FontWeight.bold,fontSize: widget.msg=="login"?13:18),),
                    SizedBox(height: 10.0),
                    Flexible(
                      child: widget.msg=="login"||widget.msg=="otp"?
                      TextFormField(
                        onTap: (){
                          setState(() {
                            erph="";
                          });
                        },
                        onChanged: (val){
                         setState(() {
                           erph="";
                         });
                        },
                        maxLength: widget.msg=="otp"?6:10,
                        controller: phone,
                        autofocus: widget.msg=="otp"?true:false,
                       decoration: InputDecoration(
                       
                         hintText: widget.msg=="otp"?"PASSWORD":"Mobile number",
                         helperText: erph,
                         helperStyle: TextStyle(color: Colors.red)

                       ),
                       keyboardType: TextInputType.number,


                      ):Text(
                        "${widget.msg}",style: TextStyle(color: Colors.green,),),
                    ),
                    SizedBox(height: 10.0),
                    Row(children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: widget.msg=="Plaese check your internet connection"||widget.msg=="Number doesn't exist in record"||widget.msg=="Login Sucessfull..."||widget.msg=="Uploaded sucessfully..."||widget.msg=="Number Blocked!..."?Text("OK"):widget.msg=="login"?Text("LOGIN"):widget.msg=="otp"?Text("VERIFY"):Text("No",style: TextStyle(fontSize: MediaQuery.of(context).size.width/32,)),
                          color: widget.msg=="login"?Colors.green:Colors.red,
                          colorBrightness: Brightness.dark,
                          onPressed: (){
                            if(widget.msg=="login"){
                              if(phone.text.length==10){
                                 setState(() {
                                 spin=true;
                                 });
                                 check_net2();
                              }else{
                                setState(() {
                                  erph="* Invalid";
                                });
                              }
                            }else if(widget.msg=="Login Sucessfull..."||widget.msg=="Number Blocked!..."){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(0)));
                            }else if( widget.msg=="otp"){
                              setState(() {
                                spin=true;
                              });
                             // signIn();
                             checkotp();
                              // err_spin("Login Sucessfull...");
                            }else{
                              Navigator.pop(context);
                                
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      widget.msg!="Plaese check your internet connection" && widget.msg!="login" && widget.msg!="Number doesn't exist in record" && widget.msg!="Login Sucessfull..." && widget.msg!="otp"&& widget.msg!="Uploaded sucessfully..." && widget.msg!="Number Blocked!..."?
                      Expanded(
                        child: RaisedButton(
                          child: Text("Yes",style: TextStyle(fontSize: MediaQuery.of(context).size.width/35,),),
                          color: Colors.green,
                          colorBrightness: Brightness.dark,
                          onPressed: (){
                            if(widget.msg=="Do you want to logout"){
                             HeadFile.saveToFile("");
                             PhoneFile.saveToFile("");
                             Navigator.pop(context);
                             
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(0)));
                            }else
                            if(widget.msg=="Do you want to delete ${widget.sub_name}"){
                            
                                Navigator.pop(context);
                              
                               
                            }else if(widget.msg=="Do you want to delete ${widget.sub_name} !"){
                           
                              Navigator.pop(context);
                             
                              
                              

                             
                            }else if(widget.msg=="Do you Re-Enter Phone Number ?"){

                            }
                            
                            
                            else{
                             exit(0);
                            }
                            
                            
                            
                            
                            },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ):Container()
                    ],)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  check_net2() async{
      try{
     final result =await InternetAddress.lookup('google.com');
     if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
       
       check_login();
      
     }
   }on SocketException catch(_){
     print('not conneted');
      
      err_spin("Plaese check your internet connection");
     
   }
    } 

 checkotp(){
   print("${phone.text}==${verificationId}}");
  if(phone.text.toString()==verificationId.toString()){
    print("login done $vevent,$vnumber");
     HeadFile.saveToFile("$vevent");
      PhoneFile.saveToFile("$vnumber");
      err_spin("Login Sucessfull...");
  }else{
    print("no login");
    setState(() {
      erph="* Wong Password";
      spin=false;
    });
  }
 }

 Map a=new Map();

 check_login()async{
  
_databaseReference.child("").once().then((DataSnapshot snapshot){
  Map<dynamic, dynamic> map = snapshot.value;
  List keylist=map.keys.toList();
  List list =map.values.toList();
  List heads=new List();
  
 
  bool ch=false;
  for(int i=0;i<list.length;i++){
    heads.clear();
     a=list[i];
    List b=a.keys.toList();
    for(int k=0;k<b.length;k++){
    if(b[k].contains("head")){
      heads.add(b[k]);
    }else{
      
    }
    }
    
       
  for(int j=0;j<heads.length;j++){
    if(list[i][heads[j]].toString()==phone.text.toString()){
      ch=true;
      print("${a['Code']}, ${keylist[i].toString()}");

     
     List l=["${a['Code']}","${keylist[i].toString()}","${phone.text}"];
     err_spin("otp",l);
       // checkotp();
    
     // verifyPhone(keylist[i].toString(),phone.text.toString());
      break;
    }
  }
  }
 
  
  if(ch==false){
     setState(() {
        spin=false;
      });
      err_spin("Number doesn't exist in record");
  }

    
  
  
});
  
    }

 Future<bool> err_spin(String dis,[var vid]) {
   setState(() {
     spin=false;
   });
     return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog("$dis",vid);
      }
    
    );
}
Future<bool> spinner(bool spin) {
     return showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog(spin);
      }
    
    );
}

}

