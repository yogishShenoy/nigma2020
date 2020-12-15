import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


import 'CanHome/home.dart';
import 'notification.dart';

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
       
  onMessage: (Map<String,dynamic> msg){
    setState(() {
         noti=true;
    });
 
  
  },

  onLaunch: (Map<String,dynamic> msg){
    setState(() {
      noti=true;
    });
    
   
  },
  onResume: (Map<String,dynamic> msg){
    setState(() {
      noti=true;
    });
    
    
  }
   );
   
 
     timer=Timer.periodic(Duration(seconds: n),(Timer){
      dotincr();
    
    });
    
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
  backgroundColor: Color.fromRGBO(88, 133, 85,1.0),

    body: SafeArea(
      child:
    ListView(children: <Widget>[
       Container(
     
       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/11,right: MediaQuery.of(context).size.width/11,),
       child:
      Image.asset("images/clg.png",fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,height: MediaQuery.of(context).size.height/9,),
     ),
     Container(
     
       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/8,right: MediaQuery.of(context).size.width/8,),
       child:
      Image.asset("images/nigma.png",fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,height: MediaQuery.of(context).size.height/12,),
     ),
     Container(
       
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/8,right: MediaQuery.of(context).size.width/8),
        child:
      Image.asset("images/logo.png",height:MediaQuery.of(context).size.height/4.5,fit: BoxFit.contain,filterQuality: FilterQuality.high),
      ),
     Container(
      
       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/8,right: MediaQuery.of(context).size.width/8),
       child:
      Image.asset("images/sam.png",fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,height: MediaQuery.of(context).size.height/11,color: Colors.lime,),
     ),
     Container(
     
       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/7,right: MediaQuery.of(context).size.width/12,),
       child:
      Image.asset("images/bottom.png",fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,height: MediaQuery.of(context).size.height/10,color: Colors.green.shade100,),
     ),
      
    
       Center(
        child:Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/8.5),
           
          height: MediaQuery.of(context).size.height/7,
          child:
         Image.asset("images/loader.gif",height:MediaQuery.of(context).size.height-630,width:MediaQuery.of(context).size.width ,color: Colors.white,),),
        
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