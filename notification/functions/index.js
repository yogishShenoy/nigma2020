const functions = require('firebase-functions');
const admin=require('firebase-admin');

admin.initializeApp(functions.config().firebase);
var msgData;

exports.offerTrigger=functions.firestore.document(
    'notifications/{notificationId}'
).onCreate((snapshot,context)=>{
    console.log('haiiiii');
 msgData=snapshot.data();
 console.log('hello',msgData);

 admin.firestore().collection('ALL_TOKENS').get().then((snapshots)=>{
     var tokens = [];
     console.log('hayyyyy');
     if (snapshots.empty){
         console.log('No Device');
         return true;
     }else{
         for(var token of snapshots.docs){
            console.log('Device found',token.data().TOKEN);
             tokens.push(token.data().TOKEN);
         }
         var payload = {
             "notification": {
                 "title": "From " + msgData.head,
                 "body":  msgData.body,
                 "sound": "default"
             },
            "data" : {
                "sendername" : msgData.head,
                "message" : msgData.body,
             }
         }

         return admin.messaging().sendToDevice(tokens,payload).then((Response)=>{
             console.log('pushed them all');
         }).catch((err)=>{
             console.log("hey erro ",err);
         })
     }
     
 })

 return true;
});