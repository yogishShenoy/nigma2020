//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:nigma2020/addShedule.dart';
import 'package:nigma2020/addclg.dart';
import 'package:nigma2020/files/file.dart';
import 'package:nigma2020/send_notification.dart';
import 'package:nigma2020/services/CRUD.dart';
import 'package:nigma2020/showResult.dart';
import 'package:url_launcher/url_launcher.dart';
import '../notification.dart';
import '../warn_close.dart';
import 'headResult/addResult.dart';
//import 'package:semaphore2020/events.dart';
//import 'package:semaphore2020/login.dart';
//import 'package:semaphore2020/services/CRUD.dart';
//import 'package:semaphore2020/warn_close.dart';
//import 'myInfo.dart';
//import 'new_log.dart';
//import 'notifications/notification.dart';


class Home extends StatefulWidget {
  @override
  int page=0;
  Home([page]){
    if(page==null){
      this.page=0;
    }else{
      this.page=page;
    }
  }
 
  _HomeState createState() => _HomeState(page);
}

class _HomeState extends State<Home> {
  //QuerySnapshot  notification;
  var appbar="HOME";
  //crudMethods crud=new crudMethods();
  _HomeState(page){
    this.page=page;
    if(page==0){
           appbar="HOME"; 
        }
        if(page==1){
            appbar="EVENTS";
        }else
        if(page==2){
           appbar="SHEDULE"; 
        }
        if(page==3){   
           appbar="RESULTS"; 
        }
  }
  final TextStyle whiteText = TextStyle(color: Colors.white);
  //final FirebaseMessaging _messaging = FirebaseMessaging();
  var event="";
  crudMethods crudup = new crudMethods();
 List alldata=new List();
 List allkey=new List();
 int page=0;
 final FirebaseMessaging _messaging = FirebaseMessaging();
 @override
 void initState(){
   super.initState();
   FirebaseDatabase.instance.reference().child("").once().then((val){
     Map ma=val.value;
     Iterable it=ma.values;
     Iterable ik=ma.keys;
     allkey=ik.toList();
     alldata=it.toList();
    // print("aa${allkey}${alldata}");
   });
    _messaging.getToken().then((token){
              // print(" i m token $token");
               
               addData(token);
                // print("i am called $token");
                 });
                   
   HeadFile.readFromFile().then((content){
                             setState(() {
                               event=content; 
                               print("i am $event");
                             });
                           });
                         
  /* crud.getNotification().then((result){
   
     setState(() {
        notification=result;
     });
     //print("noti ${notification.documents[0].documentID}");
     
   });*/
  /*_messaging.configure(
  onMessage: (Map<String,dynamic> msg){
    print("on message : $msg");
  },

  onLaunch: (Map<String,dynamic> msg){
    print("onLaunch : $msg");
  },
  onResume: (Map<String,dynamic> msg){
    print("onResume : $msg");
  }
   );*/
   
 }

 addData(var token1){
   if(token1==null){
     print("oops token is null");
   }else{
       Map<String,dynamic> tokens={
                   "TOKEN" : token1,
                 };
                 print("uploading..");
                 crudup.addToken(tokens);
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
   }
    }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child:
    Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()));
            },
            child: Image.asset("images/bell.gif",height:5,),
          )
          /*IconButton(icon: Icon(Icons.notifications_active,color: Colors.yellowAccent,size: 30,),onPressed: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckAnswersPage()));
          },),*/
        ],
        backgroundColor: Color.fromRGBO(88, 133, 85,1.0),
        elevation: 0,
        title: Text("$appbar"),
        centerTitle: true,
      ),
      bottomNavigationBar: _bottomNav(context),
      drawer: _drawer(context),
      body: appbar=="HOME"?_buildBody(context):appbar=="EVENTS"?viewEvent(context):appbar=="SHEDULE"?viewEvent(context):appbar=="RESULTS"?viewEvent(context):_buildBody(context),
      )  );
  }
  Future<bool> _onBackPressed() {
   return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog("Do you want to exit the app?");
      }
    
    );
  }
  Future<bool> _login() {
   return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog("login");
      }
    
    );
  }
  Widget _drawer(BuildContext context){
    return  Drawer(
        child: ListView(
        children:<Widget>[
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
    color: Color.fromRGBO(88, 133, 85,1.0),
  ),
          currentAccountPicture: GestureDetector(
            onTap: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyInfo()));
              },
            child:
          CircleAvatar(
                        minRadius: 60,
                        backgroundColor: Colors.blue.shade300,
                        child: CircleAvatar(
                          child: Icon(Icons.tag_faces,color: Colors.yellow,size: 50,),
                          //backgroundImage: AssetImage('assets/img/1.jpg'),
                          minRadius: 50,

                        ),
                      ),
          ),
          accountEmail: Text("femail"),
          accountName: Text("fname"),
          arrowColor: Colors.green.shade800,
        ),
        event=="" || event==null?
        Container()
        :ExpansionTile(
          title: Text("$event HEAD"),
          children: <Widget>[
            event=="REGISTRATION"?
              ListTile(
          trailing: Icon(Icons.group_add),
          title: Text("Add College",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddClg("$event")));
          }

            )
            :
            ListTile(
          trailing: Icon(Icons.send),
          title: Text("Send Notification",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SendNotification("$event")));
          }
            ),
            event=="REGISTRATION"?Container():
            ListTile(
          trailing: Icon(Icons.cloud_upload),
          title: Text("Upload Result",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddResult("$event")));
          }
            ),
            event=="REGISTRATION"?Container():
             ListTile(
          trailing: Icon(Icons.calendar_today),
          title: Text("Add/Update Shedule",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
          onTap: (){
           Navigator.push(context,  MaterialPageRoute(builder: (context)=>AddShedule(event)));
          }
            ),
          ],
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.people),
          title: Text("View Events",style: TextStyle(color: Colors.white),),
          onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(1)));
           // EmailData.saveToFile("");
           //MobileData.saveToFile("");
           // NameData.saveToFile("");
           // LogType.saveToFile("");
           // Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
         
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.calendar_today),
          title: Text("Shedule",style: TextStyle(color: Colors.white),),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(2)));
           // EmailData.saveToFile("");
           //MobileData.saveToFile("");
           // NameData.saveToFile("");
           // LogType.saveToFile("");
           // Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.assessment),
          title: Text("Event Result",style: TextStyle(color: Colors.white),),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(3)));
           // EmailData.saveToFile("");
           //MobileData.saveToFile("");
           // NameData.saveToFile("");
           // LogType.saveToFile("");
           // Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
          },
        ),
        
        
      Divider(),

        //white section
        event=="" || event ==null?
        ListTile(
          trailing: Icon(Icons.lock_open),
          title: Text("EVENT HEAD LOGIN",style: TextStyle(color: Colors.green.shade800,fontWeight: FontWeight.bold,),),
          onTap: (){
              _login();
           // EmailData.saveToFile("");
           //MobileData.saveToFile("");
           // NameData.saveToFile("");
           // LogType.saveToFile("");
           // Navigator.push(context,MaterialPageRoute(builder: (context)=>InvitationAuthPage(0)));
          },
        ):
        ListTile(
          trailing: Icon(Icons.lock_open),
          title: Text("LOGOUT",style: TextStyle(color: Colors.red.shade800,fontWeight: FontWeight.bold,),),
          onTap: (){
                 err_spin("Do you want to logout");
              //_login();
           // EmailData.saveToFile("");
           //MobileData.saveToFile("");
           // NameData.saveToFile("");
           // LogType.saveToFile("");
           // Navigator.push(context,MaterialPageRoute(builder: (context)=>InvitationAuthPage(0)));
          },
        ),
        Divider()
        ]
        ),
      );
  }
 Future<bool> err_spin(String dis) {
     return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog("$dis");
      }
    
    );
}
Widget _bottomNav(BuildContext context){
  return FancyBottomNavigation(
    circleColor: Color.fromRGBO(88, 133, 85,1.0),
    activeIconColor: Colors.white,
        initialSelection:page,
    tabs: [
        TabData(iconData: Icons.home, title: "Home"),
        TabData(iconData: Icons.people, title: "Events"),
        TabData(iconData: Icons.calendar_today, title: "Shedule"),
        TabData(iconData: Icons.assessment, title: "Results")
    ],
    onTabChangedListener: (position) {
      setState(() {
        page = position;
        //print("kbc $currentPage");
       });
       if(page==0){
          setState(() {
           appbar="HOME"; 
          });
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>student_logged()));
        }
        if(page==1){
          setState(() {
             appbar="EVENTS";
          });
        
        }else
        if(page==2){
          setState(() {
           appbar="SHEDULE"; 
          });
         
        }
        if(page==3){
          setState(() {
           appbar="RESULTS"; 
          });
         
        }
       
    },
);
}



  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      //padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 20.0),
         /* Container(
            padding: EdgeInsets.all(5),
            child:
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 190,
                      color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "9,850",
                              style:
                                  Theme.of(context).textTheme.display1.copyWith(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                      ),
                            ),
                            trailing: Icon(

                              //FontAwesomeIcons.walking,
                              Icons.assessment,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Event Registered',
                              style: whiteText,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      height: 120,
                      color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "70",
                              style:
                                  Theme.of(context).textTheme.display1.copyWith(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                      ),
                            ),
                            trailing: Icon(
                              //FontAwesomeIcons.heartbeat,
                              Icons.beenhere,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'College Registered',
                              style: whiteText,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
             Expanded(
               
                child: Column(
                  children: <Widget>[
                  GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(1)));
                },
              
                   child: Container(
                      height: 120,
                      color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "10",
                              style:
                                  Theme.of(context).textTheme.display1.copyWith(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                      ),
                            ),
                            trailing: Icon(
                             // FontAwesomeIcons.fire,
                             Icons.supervised_user_circle,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Total Events',
                              style: whiteText,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                    const SizedBox(height: 10.0),
                    Container(
                      height: 190,
                      color: Colors.purple,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "5",
                              style:
                                  Theme.of(context).textTheme.display1.copyWith(
                                        fontSize: 24.0,
                                        color: Colors.white,
                                      ),
                            ),
                            trailing: Icon(
                              Icons.border_color,
                             // FontAwesomeIcons.road,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Event Left Over',
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            
              ),
            ],
          )
          )*/
        ],
      ),
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
              height: 180,
            ),
          ),
    /*Row(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
         // color: Colors.yellowAccent,
         padding: const EdgeInsets.only(left: 10),
         child: GestureDetector(
           onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyInfo()));
           },
           // child:
        //  CircleAvatar(
                      //  minRadius: 60,
                      //  backgroundColor: Colors.red,
                        child: CircleAvatar(
                          child: Icon(Icons.tag_faces,color: Colors.yellow,size: 90,),
                          //backgroundImage: AssetImage('assets/img/1.jpg'),
                          minRadius: 50,

                        ),
                     // ),
          ),
          /*child: CircularProgressIndicator(
            value: 0.5,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
            backgroundColor: Colors.grey.shade700,
          ),*/
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DateTime.now().hour>=5&&DateTime.now().hour<12?Text(
              "Good Morning ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,color: Colors.amber),
            ):DateTime.now().hour>=12&&DateTime.now().hour<16?
            Text(
              "Good Afternoon ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,color: Colors.amber),
            ):DateTime.now().hour>=16&&DateTime.now().hour<20?
            Text(
              "Good Evening ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,color: Colors.amber),
            ):DateTime.now().hour>=20&&DateTime.now().hour<24 || DateTime.now().hour>=20&&DateTime.now().hour<5 || DateTime.now().hour>=0&&DateTime.now().hour<5? 
            Text(
              "Good Night...",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,color: Colors.amber),
            ):Text(
              "${DateTime.now().hour}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,color: Colors.amber),
            ),
            const SizedBox(height: 10.0),
              Text(
                "Yogish",
                style: whiteText.copyWith(fontSize: 20.0,color: Colors.white),
              ),
              
              Text(
                "College Id",
                style: TextStyle(color: Colors.cyan, fontSize: 16.0),
              ),
            ],
          ),
        )
      ],
    )*/
    ]);
  }

  Widget viewEvent(BuildContext context){
    return Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color:Color.fromRGBO(88, 133, 85,1.0)
              ),
              height: 200,
            ),
          ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                  child: Text("Total Events are : ${categories.length}", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ), textAlign: TextAlign.center,),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0
                  ),
                  delegate: SliverChildBuilderDelegate(
                    _buildCategoryItem,
                    childCount: categories.length,

                  )

                ),
              ),
            ],
          ),
        ],
      );
  }
 var categories = [{
   'sename':"WATER",
   'name' : "Best_Manager",
   'photo' : 'images/all/manager1.png', 
  'dis' : "The quality of a leader is reflected in the standards they set for themselves...",
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },{
    'sename':"ANIMALS",
  'name' : "Finance",
  'photo' : 'images/all/finance1.png', 
  'dis' : "Beware of little expenses. A small leak will sink a great ship...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"TREE",
   'name' : "Human_Resource",
   'photo' : 'images/all/hr2.png', 
   'dis' : "To win the marketplace,you must win the workplace...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"AIR",
   'name' : "Marketing",
   'photo' : 'images/all/market1.png', 
   'dis' : "You can't sell anything if u can't tell anything...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"OCEAN",
   'name' : "Ice_Breaker",
   'photo' : 'images/all/ice1.png', 
   'dis' : "The sea,once it casts its spell,holds one in its nets of wonder forever...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"LIGHT",
   'name' : "Photography",
   'photo' : 'images/all/photo1.png', 
   'dis' : "Photograph open doors into the past,but they also allow a look into the future...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"BIRDS",
   'name' : "Solo_Singing",
   'photo' : 'images/all/song1.png', 
   'dis' : "Keep a green tree in your heart and perhaps a singing bird will come...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"SOLAR SYSTEM",
   'name' : "Cyber_Quest",
   'photo' : 'images/all/cyber1.png', 
   'dis' : "We overcame every obstacle! We reached the sacred circle!...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"SKY",
   'name' : "Drawing",
   'photo' : 'images/all/draw1.png', 
   'dis' : "Clouds come floating into my life, no longer to carry rain or usher storm, but to add colour to my sunset sky...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"SOIL",
   'name' : "Mock Press",
   'photo' : 'images/all/mock2.png', 
   'dis' : "Find in yourself those human things which are universal...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"ICE GLACIER",
   'name' : "Mathementum_Contour",
   'photo' : 'images/all/math1.png', 
   'dis' : "If it goes too easy something is wrong...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"WESTERN GHATS",
   'name' : "Quiz",
   'photo' : 'images/all/quiz1.png', 
   'dis' : "Unlocking knowledge at the speed of thought...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },
  {
   'sename':"DESERT",
   'name' : "Rodies",
   'photo' : 'images/all/rody1.png', 
   'dis' : "The day you start saying that I'am a struggler you start losing out, dont struggle love what you do...", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },{
   'sename':"",
   'name' : "DANCE",
   'photo' : 'images/all/dance1.png', 
   'dis' : "", 
   "imgH1":'images/addBook.png',
   "imgH2":'images/addBook.png',
  },

  
];
   Widget _buildCategoryItem(BuildContext context, int index) {
   //Category category = categories[index];
   //print(" hai hai ${categories[index]['name']}");
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: ()  {
        if(appbar=="EVENTS"){
        _modalBottomSheetMenu(context,index);
        }else if(appbar=="RESULTS"){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowResults(categories[index]['name'])));
        }else{
           _sheduleBottomSheet(context,index);
        }
      },
     // _categoryPressed(context,category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //if(category.icon != null)
           // Icon(Icons.notifications_paused),
           Image.asset("${categories[index]['photo']}",height: MediaQuery.of(context).size.height-650,color: Colors.lightGreen,),
        //  if(category.icon != null)
            SizedBox(height: 5.0),
           AutoSizeText(
           categories[index]['sename'],
            textAlign: TextAlign.center,
            maxLines: 3,softWrap: true,),
            FittedBox(
         child: AutoSizeText(
           "(${categories[index]['name']})",
            textAlign: TextAlign.center,
            maxLines: 3,softWrap: true,),)
        ],
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context, int index){
    Map sdata=new Map();
    for(int i=0;i<allkey.length;i++){
      if(categories[index]['name'].toString().toUpperCase()==allkey[i]){
       // print("$i ,,, ${allkey[i]},,, ${alldata[i]}");
       try{
         setState(() {
           sdata=alldata[i];
         });
       
       /* Iterable ikey=c.keys;
        Iterable ival=c.values;
        selectedkey=ikey.toList();
        selectedval=ival.toList();
        print("${selectedkey},,${selectedval}");*/
        //print("aa, $c");
       //  print("date : ${selectedval[1]['DATE']}");
      }catch(e){
        print(e);
      }
      }
    }
        showModalBottomSheet(
            context: context,
            builder: (builder){
              return new Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade800
              ),
              height: 182,
            ),
          ),
              Container(
                height: 1000.0,
               // color: Colors.transparent, //could change this to Color(0xFF737373), 
                           //so you don't have to change MaterialApp canvasColor
                child: new Container(
                  padding: EdgeInsets.only(left: 15),
                    decoration: new BoxDecoration(
                        color: Colors.black38,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0))),
                    child: new Center(
                      child: sdata.length<=0?Text("No Data Found"):ListView(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 7)),
                          CircleAvatar(child:Image.asset("${categories[index]['photo']}",height: MediaQuery.of(context).size.height-660,color: Colors.lightGreen,),radius: 50,backgroundColor: Colors.grey.shade700,),
                          
                          Container(padding: EdgeInsets.only(top: 17),),
                          Text("${categories[index]['sename']}",textAlign: TextAlign.center,style: TextStyle(fontSize: 18),softWrap: true,),
                          Text("(${categories[index]['name']})",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),softWrap: true,),
                            Container(padding: EdgeInsets.only(top: 17),),
                          Text("${categories[index]['dis']}",textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
                           Padding(padding: EdgeInsets.only(top: 7),),
                          Text("EVENT HEADS",textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                          Padding(padding: EdgeInsets.only(top: 5),),
                         ListTile(
                           leading:Image.asset("${categories[index]['imgH1']}"),
                           title: Text("${sdata['Head1']}"),
                           trailing: IconButton(icon: Icon(Icons.call),color: Colors.green,onPressed: (){
                             launch("tel://${sdata['head1Phone']}");
                           },),
                         ),
                          Padding(padding: EdgeInsets.only(top: 5),),
                         ListTile(
                           leading:Image.asset("${categories[index]['imgH1']}"),
                           title: Text("${sdata['Head2']}"),
                           trailing: IconButton(icon: Icon(Icons.call),color: Colors.green,onPressed: (){
                             launch("tel://${sdata['head2Phone']}");
                           },),
                         ),
                         Padding(padding: EdgeInsets.only(top: 5),),
                         sdata.containsKey('Head3')?
                         ListTile(
                            leading:Image.asset("${categories[index]['imgH1']}"),
                           title: Text("${sdata['Head3']}"),
                           trailing: IconButton(icon: Icon(Icons.call),color: Colors.green,onPressed: (){
                             launch("tel://${sdata['head3Phone']}");
                           },),

                         ):Container(),

                        ],
                      ),
                    )),
              ) ]);
            }
        );
      }

  List selectedkey =new List();
  List selectedval =new List();
    List rindex=new List();
 void _sheduleBottomSheet(BuildContext context, int index){
    selectedkey.clear();
    selectedval.clear();
    rindex.clear();
    for(int i=0;i<allkey.length;i++){
      if(categories[index]['name'].toString().toUpperCase()==allkey[i]){
       // print("$i ,,, ${allkey[i]},,, ${alldata[i]}");
       try{
        Map c=alldata[i];
        Iterable ikey=c.keys;
        Iterable ival=c.values;
        selectedkey=ikey.toList();
        selectedval=ival.toList();
        print("${selectedkey},,${selectedval}");
       for(int j=0;j<selectedkey.length;j++){
         bool r=selectedkey[j].toString().contains('Round');
                  if(r){
                    rindex.add(j);
                  }
       

        }
       // print("rindex, $rindex");
       //  print("date : ${selectedval[1]['DATE']}");
      }catch(e){
        print(e);
      }
      }
    }
    

        showModalBottomSheet(
            context: context,
            builder: (builder){
              return new Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade800
              ),
              height: 182,
            ),
          ),
              Container(
                height: 1000.0,
               // color: Colors.transparent, //could change this to Color(0xFF737373), 
                           //so you don't have to change MaterialApp canvasColor
                child: new Container(
                  padding: EdgeInsets.only(left: 15),
                    decoration: new BoxDecoration(
                        color: Colors.black38,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0))),
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Image.asset("${categories[index]['photo']}",height: MediaQuery.of(context).size.height-670,color: Colors.lightGreen,),
                          
                          Container(padding: EdgeInsets.only(top: 10),),
                          Text("${categories[index]['sename']}",textAlign: TextAlign.center,),
                          Text("(${categories[index]['name']})",textAlign: TextAlign.center,),
                           Padding(padding: EdgeInsets.only(top: 10),),
                          Text("Total Rounds: ${rindex.length}",textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                            Container(padding: EdgeInsets.only(top: 10),),
                            Expanded(

                            child:rindex.length<=0?Center(child:Text("Rounds Not added")):
                            ListView.builder(
                              itemCount: rindex.length,
                              itemBuilder: ((context,ind){
                                return Column(
                                  children: <Widget>[
                                    boxdesign(ind),
                                     Padding(padding: EdgeInsets.only(top: 10),),
                                  ],
                                );
                              }),
                            )
                            ),
                              
                               
                               /* boxdesign(),
                                Padding(padding: EdgeInsets.only(top: 10),),
                                boxdesign(),
                                Padding(padding: EdgeInsets.only(top: 10),),
                                boxdesign(),
                                Padding(padding: EdgeInsets.only(top: 10),),
                                boxdesign(),*/
                      /*  GridView.count(
                         crossAxisCount: 2,
                         scrollDirection: Axis.vertical,
                         children: List.generate(5, (i){
                           return Center(
                             child: Container(
                               decoration: BoxDecoration(
                                 border :Border.all(color:  Colors.grey,width: 3.0),
                               ),
                               child: Text("hai"),
                             ),
                           );
                         }),
                        ),*/
                          
                        ],
                      ),
                    )),
              ) ]);
            }
        );

       
      }
      
 Widget boxdesign(i){
          return Padding(padding: EdgeInsets.only(right: 10),child: 
          MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: ()  {
      /*  if(appbar=="EVENTS"){
        _modalBottomSheetMenu(context,index);
        }else{
          _sheduleBottomSheet(context,index);
        }*/
      },
     // _categoryPressed(context,category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //if(category.icon != null)
           // Icon(Icons.notifications_paused),
           ListTile(
               leading: Column(
                 children:<Widget>[
                   Icon(Icons.alarm,color: Colors.green.shade300,size: 35,),
                   Padding(padding: EdgeInsets.only(bottom: 2),),
               Text("${selectedkey[rindex[i]]}",textAlign: TextAlign.center,),
                 ]
               ),
               title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                  Text("DATE : ${selectedval[rindex[i]]['DATE']}"),
                   Text("Room No : ${selectedval[rindex[i]]['ROOM']}"),
                 ],
               ),
               subtitle:
               Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Text("From : ${selectedval[rindex[i]]['START']}",),
                   Text("To: ${selectedval[rindex[i]]['END']}"),
                 ],
               ),
           ),
           
           //Image.asset("${categories[0]['photo']}",height: MediaQuery.of(context).size.height-650,color: Colors.lightGreen,),
        //  if(category.icon != null)
            
        ],
      ),
          )
    );
   }
        



   Widget result(BuildContext context){
    return Container(
     child: Center(
       child: Text("No Result"),
    
    ),
    );
  }
  
}