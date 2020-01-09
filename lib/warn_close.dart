import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nigma2020/CanHome/home.dart';
import 'package:nigma2020/Loading_dia.dart';

import 'files/file.dart';
//import 'package:semaphore2020/new_log.dart';
//import 'package:instant_mca/student/reminder/DBHelper.dart';
//import 'package:instant_mca/student/student_logged.dart';
//import './student/attendence/offline_db/attendence_helper.dart';
//import 'files/conn1.dart';
//import 'login.dart';
class BeautifulAlertDialog extends StatefulWidget {
  var msg,delid,sub_name="";
  List vid;
  BeautifulAlertDialog(this.msg,[this.vid]){
  //print("i m msg=$msg");
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
  var verificationId;
  @override
  void initState(){
   super.initState();
    spin=false;
   if(widget.vid!=null){
     print("${widget.vid[0]} : ${widget.vid[1]} :${widget.vid[2]}");
     verificationId=widget.vid[0];
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
              CircleAvatar(radius: widget.msg=="login"?40:55, backgroundColor: Colors.grey.shade300, child:widget.msg=="Plaese check your internet connection"?Icon(Icons.signal_cellular_connected_no_internet_4_bar,color: Colors.red.shade900,size: 50,):Image.asset(widget.msg=="login"?"images/all/manager1.png":widget.msg=="Login Sucessfull..."?"images/done.gif":widget.msg=="otp"?"images/mobile.png":'images/warn.png', width: widget.msg=="login"?50:60,height:60),),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   
                    Text(widget.msg=="otp"?"OTP":widget.msg=="login"?"EVENT HEAD LOGIN":widget.msg=="Login Sucessfull..."?"":"Alert !", style: TextStyle(color:widget.msg=="login"?Colors.green: Colors.red,fontWeight: FontWeight.bold,fontSize: widget.msg=="login"?13:18),),
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
                        // prefix: Icon(Icons.phone_iphone,color: Colors.blue,),
                         hintText: widget.msg=="otp"?"OTP":"Mobile number",
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
                          child: widget.msg=="Plaese check your internet connection"||widget.msg=="Number doesn't exist in record"||widget.msg=="Login Sucessfull..."?Text("OK"):widget.msg=="login"?Text("LOGIN"):widget.msg=="otp"?Text("VERIFY"):Text("No",style: TextStyle(fontSize: MediaQuery.of(context).size.width/32,)),
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
                            }else if(widget.msg=="Login Sucessfull..."){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(0)));
                            }else if( widget.msg=="otp"){
                              setState(() {
                                spin=true;
                              });
                              signIn();
                              // err_spin("Login Sucessfull...");
                            }else{
                              Navigator.pop(context);
                                
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      widget.msg!="Plaese check your internet connection" && widget.msg!="login" && widget.msg!="Number doesn't exist in record" && widget.msg!="Login Sucessfull..." && widget.msg!="otp"?
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
                             
                            // Mobile_File.saveToFile("");
                            // Name_File.saveToFile("");
                            //  Email_File.saveToFile("");
                            // Batch_File.saveToFile("");
                            //  Bid_File.saveToFile("");
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(0)));
                            }else
                            if(widget.msg=="Do you want to delete ${widget.sub_name}"){
                             //  AttendeceHelper x =new AttendeceHelper();
                             //  x.delete(delid);
                                Navigator.pop(context);
                               // Navigator.push(context, MaterialPageRoute(builder: (context)=>student_logged(pagenum: 2)));
                              // student_logged(todos: List.generate(1, (i)=>Todo(2)));
                               
                            }else if(widget.msg=="Do you want to delete ${widget.sub_name} !"){
                           
                             // Batch_File.readFromFile().then((content){
                            // var batch= content.toString();
                            //  if(batch!=""){
                            // print("i am file $batch");
                            // get_num_data(batch);
                           // NoteHelper y=new NoteHelper();
                           // String usn=get_usn();
                            // y.delete(delid);
                              Navigator.pop(context);
                             // Navigator.push(context, MaterialPageRoute(builder: (context)=>student_logged(pagenum: 3)));
                         //  }else{
                            // print("error");
                          // }
                         //  });
                              
                              

                             
                            }else if(widget.msg=="Do you Re-Enter Phone Number ?"){
                               // Navigator.push(context, MaterialPageRoute(builder: (context)=>InvitationAuthPage(0)));
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
      // addData();
      //verifyPhone();
     }
   }on SocketException catch(_){
     print('not conneted');
      
      err_spin("Plaese check your internet connection");
     
   }
    } 

     signIn() async {
       print("${phone.text},$verificationId");
      
   AuthCredential credential = PhoneAuthProvider.getCredential(
  verificationId: verificationId,
  smsCode: phone.text,
);
       

FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseUser user =
    await _auth.signInWithCredential(credential).then((user) {
      //print("user is $user");
     HeadFile.saveToFile("${widget.vid[1]}");
      PhoneFile.saveToFile("${widget.vid[2]}");
    err_spin("Login Sucessfull...");
}).catchError((e) {
  print("please enter again : $e");
  setState(() {
    erph="* Verify the SMS code";
  });
});
 }

    Future<void> verifyPhone(String event,String number) async{
   final PhoneCodeAutoRetrievalTimeout autoRetrieve =(String verId){
     setState(() {
         verificationId=verId;
     });
  
     //print('veri01 $verificationId');
   };
   final PhoneCodeSent smsCodeSent =(String verId,[int forceCodeResend]){
     setState(() {
       verificationId=verId;
     });
     List l=["$verificationId","$event","$number"];
      err_spin("otp",l);
      print('veri02 $verificationId, forceint $forceCodeResend');
      
   };
   final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
     print('verified');
      HeadFile.saveToFile("$event");
      PhoneFile.saveToFile("$number");
      err_spin("Login Sucessfull...");
      
    
     
     //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
   };
   final PhoneVerificationFailed verifiFailed=(AuthException exception){
    print('error i am ${exception.message}');
   };
   await FirebaseAuth.instance.verifyPhoneNumber(
     phoneNumber:  "+91"+phone.text,
     codeAutoRetrievalTimeout: autoRetrieve,
     codeSent: smsCodeSent,
     timeout: const Duration(seconds: 5),
     verificationFailed: verifiFailed,
     verificationCompleted: verifiedSuccess,
   );
  // Navigator.push(context, MaterialPageRoute(builder: (context)=>InvitationAuthPage(1,phone.text)));
 }

 /*List arr=[
   "BEST MANAGER","FINANCE","HUMAN RESOURCE","MARKETING","ICE BREAKER","PHOTOGRAPHY","SOLO SINGING","CYBER QUEST","DRAWING","MOCK PRESS","MATHEMENTUM CONTOUR","QUIZ","RODIES","DANCE"
 ];*/

 check_login()async{
  
_databaseReference.child("").once().then((DataSnapshot snapshot){
  Map<dynamic, dynamic> map = snapshot.value;
  List keylist=map.keys.toList();
  List list =map.values.toList();
  bool ch=false;
  for(int i=0;i<list.length;i++){
    if(list[i]['head1Phone'].toString()==phone.text.toString()){
      print("number exist in 1");
      ch=true;
      //err_spin("otp");
      //spinner(true);
      
      verifyPhone(keylist[i].toString(),phone.text.toString());
      break;
    }else if(list[i]['head2Phone'].toString()==phone.text.toString()){
     print("number exist in 2");
     ch=true;
    //err_spin("otp");
    // spinner(true);
    
     verifyPhone(keylist[i].toString(),phone.text.toString());
      break;
    }
  }
  if(ch==false){
     setState(() {
        spin=false;
      });
      err_spin("Number doesn't exist in record");
  }

    //print("i ma  ${keylist[0]},${list[0]['head1Phone']}");
    
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
     return spin?showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog(spin);
      }
    
    ):Navigator.pop(context);
}



/*Future<bool> check_login() {
    final double width=MediaQuery.of(context).size.width;
    return spin_loader?
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog();
      }
    
    ):Navigator.pop(context);
  }*/
}

