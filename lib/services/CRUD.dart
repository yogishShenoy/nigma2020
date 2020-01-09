import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class crudMethods{
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

  getNotification()async{
    try{
   return await Firestore.instance.collection('notifications').getDocuments();
    }catch(e){
      print("i am e2 $e");
    }

 }
}