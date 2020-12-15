import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';




class crudMethods{
   
 Future<void> addToken(token)async{
  Firestore.instance.collection('ALL_TOKENS').document(token["TOKEN"]).setData(token).catchError((e){
  });

 }

 Future sendNotification(data)async{
   Firestore.instance.collection('notifications').add(data).catchError((e){
  
  });
 }
Future addRound(event,round,data)async{
FirebaseDatabase.instance.reference().child("$event/$round").set(data);

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
     
    }

 }
}