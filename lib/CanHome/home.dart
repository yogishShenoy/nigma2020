
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
import 'package:device_apps/device_apps.dart';



class Home extends StatefulWidget {
  @override
  int page=0;
  var type="";
  Home(page,[type]){
    if(page==null){
      this.page=0;
    }else{
      this.page=page;
    }

   
  }
 
  _HomeState createState() => _HomeState(page);
}

class _HomeState extends State<Home> {
 
  var appbar="HOME";
 
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
 
  var event="";
  crudMethods crudup = new crudMethods();
 List alldata=new List();
 List allkey=new List();
 int page=0;
 final FirebaseMessaging _messaging = FirebaseMessaging();
 @override
 void initState(){
   super.initState();

      _messaging.configure(
    
  onMessage: (Map<String,dynamic> msg){
   
   
  },

  onLaunch: (Map<String,dynamic> msg){

  },
  onResume: (Map<String,dynamic> msg){
   
    
  }
   );


   FirebaseDatabase.instance.reference().child("").once().then((val){
     Map ma=val.value;
     Iterable it=ma.values;
     Iterable ik=ma.keys;
     allkey=ik.toList();
     alldata=it.toList();
   
   });
    _messaging.getToken().then((token){
              
               
               addData(token);
                 });
                   
   HeadFile.readFromFile().then((content){
                             setState(() {
                               event=content; 
                              
                             });
                           });
   
 }
 Future insta()async{
    bool isInstalled = await DeviceApps.isAppInstalled('com.instagram.android');
           if(isInstalled){
              DeviceApps.openApp('com.instagram.android');
           }
 }

 addData(var token1){
   if(token1==null){
    
   }else{
       Map<String,dynamic> tokens={
                   "TOKEN" : token1,
                 };
                
                 crudup.addToken(tokens);
                    
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
          Container(
            color:Color.fromRGBO(88, 120, 80,1.0) ,
        
           padding: EdgeInsets.only(top: 10,bottom: 30),
            child: Column(
               children: <Widget>[
                 
                   

                
                 Center(
                   child:
                        FittedBox(child: Image.asset('images/logo.png',height: MediaQuery.of(context).size.height/5,fit: BoxFit.fitWidth,),),
                        
      
                 ),
               ],
            ),
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
           
         
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.calendar_today),
          title: Text("Shedule",style: TextStyle(color: Colors.white),),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(2)));
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.assessment),
          title: Text("Event Result",style: TextStyle(color: Colors.white),),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(3)));
          },
        ),
        Divider(),
        ListTile(
          subtitle: Text("nigm2020",style: TextStyle(color: Colors.yellow.shade300,fontSize: 15),),
         trailing: FittedBox(
           fit: BoxFit.cover,
           child: Image.asset("images/insta.png"),
           
         ),
         title: Text("Follow us :",
         style: TextStyle(color: Colors.white),),
         onTap: (){
          
        insta();
         },
        ),
        
      Divider(),

        event=="" || event ==null?
        ListTile(
          trailing: Icon(Icons.lock_open),
          title: Text("EVENT HEAD LOGIN",style: TextStyle(color: Colors.green.shade800,fontWeight: FontWeight.bold,),),
          onTap: (){
              _login();
          },
        ):
        ListTile(
          trailing: Icon(Icons.lock_open),
          title: Text("LOGOUT",style: TextStyle(color: Colors.red.shade800,fontWeight: FontWeight.bold,),),
          onTap: (){
                 err_spin("Do you want to logout");
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
        
       });
       if(page==0){
          setState(() {
           appbar="HOME"; 
          });
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
      child: Column(
        children: <Widget>[
         _buildHeader(),
          
          const SizedBox(height: 20.0),
        
          Container(
            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/1.5),
            child:
          OutlineButton(
            onPressed: (){

            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              borderSide: BorderSide(
            color: Colors.green, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 5, //width of the border
          ),   
          child: Text("     Theme     "),
          ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 10),
            child:
          Text('SAMSTHITI means togetherness. We 7 billion Humans share this incredible enormous Planet with vast variety of plants and animals together. The basis of our togetherness lies in the existence of 5 basic elements namely Earth, Air Water, fire and Sky Togetherness is an integral part of our life. It unites us, gives us security, much needed support and a sense of belonging and encourage us to love one another. To know we are all in this planet together is a wonderful feeling because we are the chosen one!!!',softWrap: true,style: TextStyle(color: Colors.green.shade200,fontSize: MediaQuery.of(context).size.width/25,fontWeight: FontWeight.bold),),
          ),
Center(
  child:
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 20),
           child: 
           Text("SAMSTHITI LEADS PRAKRUTHI TO BE IN SWASTHI.",softWrap: true,style: TextStyle(color: Colors.green.shade400,fontSize: MediaQuery.of(context).size.width/28,fontWeight: FontWeight.bold),),
          ),
),
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
              height: MediaQuery.of(context).size.height/3.5,
            ),
          ),
          Center(
            child: Image.asset("images/logo.png",height: MediaQuery.of(context).size.height/5.1,),
          )

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
   'name' : "Roadies",
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
    
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child:
       Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         
          
            Container(
               height: MediaQuery.of(context).size.height/10,
               child:
           Image.asset("${categories[index]['photo']}",height: MediaQuery.of(context).size.height-650,color: Colors.lightGreen,),
           ),
           
       
            SizedBox(height: 5.0),
           AutoSizeText(
           categories[index]['name'],
            textAlign: TextAlign.center,
            maxLines: 3,softWrap: true,),
            FittedBox(
         child: AutoSizeText(
           "(${categories[index]['sename']})",
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

       try{
         setState(() {
           sdata=alldata[i];
         });
       
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
              
                child: new Container(
                  padding: EdgeInsets.only(left: 15),
                    decoration: new BoxDecoration(
                        color: Colors.black38,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0))),
                    child: new Center(
                      child: sdata.length<=0?
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4.8),
                        child:
                      Column(
                        children:<Widget>[
                      Icon(Icons.signal_wifi_off,size: MediaQuery.of(context).size.height/8,color: Colors.red.shade300,),
                       Padding(padding: EdgeInsets.only(top: 7)),
                      Text("No Connection...",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.red,fontSize: MediaQuery.of(context).size.width/16))])):ListView(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 7)),
                          CircleAvatar(
                            child:
                          Container(
                            height: MediaQuery.of(context).size.height/9.5,
                            child:
                          Image.asset("${categories[index]['photo']}",height: MediaQuery.of(context).size.height-660,color: Colors.lightGreen,),
                          ),radius: 50,backgroundColor: Colors.grey.shade700,),
                          
                          Container(padding: EdgeInsets.only(top: 17),),
                          Text("${categories[index]['name']}",textAlign: TextAlign.center,style: TextStyle(fontSize: 18),softWrap: true,),
                          Text("(${categories[index]['sename']})",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),softWrap: true,),
                            Container(padding: EdgeInsets.only(top: 17),),
                          Text("${categories[index]['dis']}",textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
                           Padding(padding: EdgeInsets.only(top: 7),),
                          Text("EVENT HEADS",textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                          Padding(padding: EdgeInsets.only(top: 5),),
                         ListTile(
                           leading:Image.asset("images/all/hr3.png",color: Colors.lime,),
                           title: Text("${sdata['Head1']}"),
                           trailing: IconButton(icon: Icon(Icons.call),color: Colors.green,onPressed: (){
                             launch("tel://${sdata['head1Phone']}");
                           },),
                         ),
                          Padding(padding: EdgeInsets.only(top: 5),),
                         ListTile(
                           leading:Image.asset("images/all/hr3.png",color: Colors.lime),
                           title: Text("${sdata['Head2']}"),
                           trailing: IconButton(icon: Icon(Icons.call),color: Colors.green,onPressed: (){
                             launch("tel://${sdata['head2Phone']}");
                           },),
                         ),
                         Padding(padding: EdgeInsets.only(top: 5),),
                         sdata.containsKey('Head3')?
                         ListTile(
                            leading:Image.asset("images/all/hr3.png",color: Colors.lime),
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
    Map mapc=new Map();
 void _sheduleBottomSheet(BuildContext context, int index){
    selectedkey.clear();
    selectedval.clear();
    rindex.clear();
    setState(() {
      
    });
    for(int i=0;i<allkey.length;i++){
      if(categories[index]['name'].toString().toUpperCase()==allkey[i]){
       try{
        mapc=alldata[i];
        Iterable ikey=mapc.keys;
        Iterable ival=mapc.values;
        selectedkey=ikey.toList();
        selectedval=ival.toList();

        selectedkey.sort();
        
       
       for(int j=0;j<selectedkey.length;j++){
         bool r=selectedkey[j].toString().contains('Round');
                  if(r){
                    rindex.add(j);
                  }
       

        }

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
                          Container(
                            height: MediaQuery.of(context).size.height/9,
                            child:
                          Image.asset("${categories[index]['photo']}",color: Colors.lightGreen,fit: BoxFit.cover,),
                          ),
                          
                          Container(padding: EdgeInsets.only(top: 10),),
                          Text("${categories[index]['name']}",textAlign: TextAlign.center,),
                          Text("(${categories[index]['sename']})",textAlign: TextAlign.center,),
                           Padding(padding: EdgeInsets.only(top: 10),),
                          Text("Total Rounds: ${rindex.length}",textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                            Container(padding: EdgeInsets.only(top: 10),),
                            Expanded(

                            child:rindex.length<=0?Center(child:Text("Rounds Not Found...")):
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
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
           ListTile(
              isThreeLine: true,
              trailing: Icon(Icons.alarm,color: Colors.green.shade300,size: 35,),
               leading: 
               FittedBox(
                 child:Column(
                 children:<Widget>[
                   OutlineButton(
                     child: Text("${selectedkey[rindex[i]]}",textAlign: TextAlign.center,),
                     onPressed: (){

                     },
                     shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 5, //width of the border
          ),   

                   ),
               
                 ]
                 )
               ),
               title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                  Text("DATE : ${mapc[selectedkey[rindex[i]]]['DATE']}",textAlign: TextAlign.left,),
                   Text("Place/Room : ${mapc[selectedkey[rindex[i]]]['ROOM']}",textAlign: TextAlign.left),
                 ],
               ),
               subtitle:
               Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Text("From : ${mapc[selectedkey[rindex[i]]]['START']}",),
                   Text("  To : ${mapc[selectedkey[rindex[i]]]['END']}"),
                 ],
               ),
           ),
           
            
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