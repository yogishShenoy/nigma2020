import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'CanHome/home.dart';
import 'notification.dart';
//import 'login.dart';
//import 'new_log.dart';
class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  var dot=".";
  Timer timer;
  int n=1;
   startTimer() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, ask);
  }
  ask(){
    timer?.cancel();
    noti?
  Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications())):
   Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(0,"")) );

   }
   @override
   void dispose(){
     timer?.cancel();
     super.dispose();
   }
   void dotincr(){
      if(dot=="."){
       setState(() {
         dot="..";
        
       });
     }else if(dot==".."){
     setState(() {
       dot="...";
       
     });
     }else{
       setState(() {
         dot=".";
          print("${MediaQuery.of(context).size.height.toString()}");
       });
     }
   }
   bool noti=false;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  void initState(){
    super.initState();
    noti=false;
     _messaging.configure(
       /* onBackgroundMessage: (Map<String,dynamic>msg){
         setState(() {
           noti=true;
         });
          
           print("on onBackgroundMessage001 : $msg");
        },*/
  onMessage: (Map<String,dynamic> msg){
    setState(() {
         noti=true;
    });
 
    print("on message : $msg");
  },

  onLaunch: (Map<String,dynamic> msg){
    setState(() {
      noti=true;
    });
    
    print("onLaunch : $msg");
  },
  onResume: (Map<String,dynamic> msg){
    setState(() {
      noti=true;
    });
    
    print("onResume : $msg");
  }
   );
   
 
     timer=Timer.periodic(Duration(seconds: n),(Timer){
      dotincr();
     //print("hai");
    });
    
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   //backgroundColor: Colors.green.shade700,
  backgroundColor: Colors.black,

    body: SafeArea(
      child:
    ListView(children: <Widget>[
     Container(
      //height: MediaQuery.of(context).size.height/7,
       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/5,right: MediaQuery.of(context).size.width/5,top: 40),
       child:
      Image.asset("images/nigma.jpeg",fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,),
     ),
     Container(
       //height: MediaQuery.of(context).size.height/6,
        margin: EdgeInsets.only(left: 10,right: 10,top: 30),
        child:
      Image.asset("images/slogo.jpeg",height:MediaQuery.of(context).size.height/4.5,fit: BoxFit.contain,filterQuality: FilterQuality.high),
      ),
     Container(
       // height: MediaQuery.of(context).size.height/7,
       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/7,right: MediaQuery.of(context).size.width/7,top: 30),
       child:
      Image.asset("images/sam.jpeg",fit: BoxFit.fitWidth,filterQuality: FilterQuality.high),
     ),
      
       /*Positioned(
         height: 1050,
         left: 50,
         right: 50,
        //margin: EdgeInsets.only(left: 10,right: 10,top: 30),
        child:
      //Image.asset("images/loader.gif",fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,height: 10,),
      ),*/
       //Image.asset("images/splash1.gif",height:MediaQuery.of(context).size.height,width:MediaQuery.of(context).size.width ,fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,),
       Center(
        child:Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/3.5),
           // SpinKitWave(color: Colors.red,type: SpinKitWaveType.start,),
          // SpinKitPumpingHeart(color: Colors.lightGreenAccent),
          height: MediaQuery.of(context).size.height/7,
          child:
         Image.asset("images/loader.gif",height:MediaQuery.of(context).size.height-630,width:MediaQuery.of(context).size.width ,color: Colors.green,),),
           // Text("Loading $dot",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
           RichText(
             text:TextSpan(
               text: 'Loading',
               style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
               children: <TextSpan>[
                 TextSpan(text: "$dot",style: TextStyle(color: Colors.lightGreenAccent,fontWeight: FontWeight.bold,fontSize: 30),)
               ]
             ),
           )
        ],)
         
      ),
     ],),
    )
    );
  
    
  }
}