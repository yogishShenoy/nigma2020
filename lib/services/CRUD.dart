import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../warn_close.dart';

class crudMethods{
   //DatabaseReference _databaseReference =FirebaseDatabase.instance.reference();
 Future<void> addToken(token)async{
 /*Firestore.instance.collection('ALL TOKENS').add(token).catchError((e){
    print("error is $e");
  });*/
  
  
  Firestore.instance.collection('ALL_TOKENS').document(token["TOKEN"]).setData(token).catchError((e){
    print("error is $e");
  });
 // .setData(token).
 //Map t= token;
 //print(" i m ${t['TOKEN']}");
 // DatabaseReference databaseReference = new FirebaseDatabase().reference();
  //databaseReference.child('ALL_TOKENS/PToken/${t['TOKEN']}').set((token));



 }

 Future sendNotification(data)async{
   Firestore.instance.collection('notifications').add(data).catchError((e){
    print("error is $e");
  });
 }
Future addRound(event,round,data)async{
FirebaseDatabase.instance.reference().child("$event/$round").set(data);
print("i am called");
}
Future removeRound(event,round)async{
FirebaseDatabase.instance.reference().child("$event/$round").remove();
}

Future addColleges(data)async {
  FirebaseDatabase.instance.reference().child("COLLEGES/${data['CODE']}").set(data);
}
Future addResult(event,round,data)async{
 FirebaseDatabase.instance.reference().child("$event/$round/RESULT").set(data);
}

  getNotification()async{
    try{
   return await Firestore.instance.collection('notifications').getDocuments();
    }catch(e){
      print("i am e2 $e");
    }

 }
}