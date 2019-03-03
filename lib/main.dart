import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:animated_background/animated_background.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:ui' as ui;
String ip="192.168.0.1";
String session="0";
String user="temp";
String pass="temp";
List<String> tv,ac,fan,tubelight;
String tvs,acs,fans,tubelights;
String mode;
DateTime currentBackPressTime = DateTime.now();
Behaviour animation=new BubblesBehaviour();
Future<String> load_devices(String room) async
{
  var response = await http.get("http://"+ip+"/smart/getmode.php");
  if(response.statusCode==200) {
    mode = response.body.toString();
    if (mode == "1") {
      response = await http.get(
          "http://" + ip + "/smart/get_id.php?device=tv&room=" + room);
      tvs = response.body.toString();
      tv = tvs.split(",");
      response = await http.get(
          "http://" + ip + "/smart/get_id.php?device=ac&room=" + room);
      acs = response.body.toString();
      ac = acs.split(",");
      response = await http.get(
          "http://" + ip + "/smart/get_id.php?device=fan&room=" + room);
      fans = response.body.toString();
      fan = fans.split(",");
      response = await http.get(
          "http://" + ip + "/smart/get_id.php?device=tubelight&room=" + room);
      tubelights = response.body.toString();
      tubelight = tubelights.split(",");
    }
  }
  else
  {
    tv=[];
    ac=[];
    fan=[];
    tubelight=[];
    mode="0";
  }
  return "done";
}
void getip() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try
  {
    String data=prefs.get("ip");
    List<String> list=data.split(",");
    ip=list[0];
    session=list[1];
    user=list[2];
    pass=list[3];
  }
  catch(e)
  {

    prefs.setString("ip","192.168.0.1,0,temp,temp");
    String data=prefs.get("ip");
    List<String> list=data.split(",");
    ip=list[0];
    session=list[1];
    user=list[2];
    pass=list[3];
  }

}
void main() async
{
  getip();
  Future.delayed(const Duration(milliseconds:1000), ()
  {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(new app());

  });

}
class app extends StatelessWidget
{


  Widget build(BuildContext bc)
  {
    return new MaterialApp(
      theme: ThemeData.light(),
      home:new Scaffold(
        resizeToAvoidBottomPadding: false,
        body:home(),

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class login extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new loginstate();
  }
}

class loginstate extends State<login> with TickerProviderStateMixin{
  final user1 = TextEditingController();
  final pass1= TextEditingController();

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
  void login() async
  {
      if(user1.text==user && pass1.text==pass)
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("ip", ip + "," + "1" + "," + user + "," + pass);
        session="1";
        Navigator.of(context).push(new success_loginpageroute());
      }
      else
        {
          Fluttertoast.showToast(msg:"Please provide proper username and password");
        }

   // Navigator.of(context).pop();
  }

  Widget build(BuildContext bc)
  {

    return  new WillPopScope(
        onWillPop:_onWillPop,
    child:Scaffold(
        resizeToAvoidBottomPadding: true,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/main.jpg"),
              fit: BoxFit.cover,
              color: Color(0000000).withOpacity(0.90),
              colorBlendMode: BlendMode.darken,


            ),
            new AnimatedBackground(
              behaviour:animation,
              vsync: this,
              child: new Text(""),
            ),
            new Center(
              child: new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //new Image.asset('assets/Manual.png',width: 100,height: 82,fit: BoxFit.fill,color: Colors.white,),
                      new Padding(padding: EdgeInsets.all(10),),
                      new Icon(MdiIcons.homeCityOutline,size: 100,color: Colors.white,),
                      new Padding(padding: EdgeInsets.all(10),),
                      Text("smARt",style: TextStyle(color:Colors.white,fontSize:70,fontFamily:'po'),),
                      Text("Welcome to AR based smart home ",style: TextStyle(color:Colors.white,fontSize:20,fontFamily:'po')),
                      new Padding(padding: EdgeInsets.only(bottom: 50)),
                      new Container(
                        child: new Form(
                          child: Column(
                            children: <Widget>[
                              new SizedBox(
                                width: 300,
                                child:new TextField(
                                  controller: user1,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
//                                icon:Icon(Icons.account_box,color: Colors.white,),
                                      prefixIcon: Icon(Icons.account_box,color: Colors.white,),
                                      hintText: "Username",
                                      hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                                  ),
                                  style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),

                                ),
                              ),
                              new Padding(padding:EdgeInsets.all(20)),
                              new SizedBox(
                                width: 300,
                                child:new TextField(
                                  controller: pass1,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon:Icon(Icons.lock,color: Colors.white,),
                                      hintText: "Password",
                                      hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                                  ),
                                  style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),
                                  obscureText: true,

                                ),
                              ),
                              new Padding(padding:EdgeInsets.all(20)),
                              new SizedBox(
                                width: 300,
                                child:  new MaterialButton( 
                                  splashColor: Colors.deepOrange,
                                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                                  child: Text("Login",style:TextStyle(color:Colors.black,fontSize:40,fontFamily: 'po',fontWeight: FontWeight.bold),),
                                  shape: new CircleBorder(),
                                  color: Colors.white,
                                  onPressed: () {
                                    login();

                                  },
                                ),
                              ),
                              new Padding(padding:EdgeInsets.all(20)),

                            ],
                          ),
                        ),
                      )
                    ],)
                ],
              ),
            )


          ],
        )

    ));
  }
}
class success_loginpageroute extends CupertinoPageRoute {
  success_loginpageroute()
      : super(builder: (BuildContext context) => new MyHomePage());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new MyHomePage());
  }
}
class loginpageroute extends CupertinoPageRoute {
  loginpageroute()
      : super(builder: (BuildContext context) => new app());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new app());
  }
}
class home extends StatelessWidget {
  @override
  Widget widgetbuild()
  {
    if(session=="0")
      return login();
    else
      return MyHomePage();
  }
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData.dark(),
      home: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body:widgetbuild(),

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class  MyHomePageroute extends CupertinoPageRoute {
  MyHomePageroute()
      : super(builder: (BuildContext context) => new MyHomePage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new MyHomePage());
  }
}
class  hardwareroute extends CupertinoPageRoute {
  hardwareroute()
      : super(builder: (BuildContext context) => new hardware());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new hardware());
  }
}
class  smartmoderoute extends CupertinoPageRoute {
  smartmoderoute()
      : super(builder: (BuildContext context) => new smartmode());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new smartmode());
  }
}
class  logoutroute extends CupertinoPageRoute {
  logoutroute()
      : super(builder: (BuildContext context) => new login());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new login());
  }
}
class  configroute extends CupertinoPageRoute {
  configroute()
      : super(builder: (BuildContext context) => new config());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new config());
  }
}
class  passwordr extends CupertinoPageRoute {
  passwordr()
      : super(builder: (BuildContext context) => new passwordpage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new passwordpage());
  }
}
class  userr extends CupertinoPageRoute {
  userr()
      : super(builder: (BuildContext context) => new usernamepage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new usernamepage());
  }
}
void chnguser(BuildContext context)
{
  Navigator.of(context).push(new userr());
}
void chngpass(BuildContext context)
{
  Navigator.of(context).push(new passwordr());
}
void switch_modetap(BuildContext context)
{
  Navigator.of(context).push(new MyHomePageroute());
}
void hardwaretap(BuildContext context)
{
  load_devices("hardwarelab");
  Future.delayed(const Duration(milliseconds:700), () {
    if(mode=="1")
    {
      Navigator.of(context).push(new hardwareroute());
    }
    else {
      Fluttertoast.showToast(
        msg: "You are not in smart mode",
        toastLength: Toast.LENGTH_LONG,

      );
      Navigator.of(context).push(new MyHomePageroute());
    }

  });
}
void smartmodetap(BuildContext context)
{
  Future.delayed(const Duration(milliseconds:700), () {
    if(mode=="1")
    {
      Navigator.of(context).push(new smartmoderoute());
    }
    else {
      Fluttertoast.showToast(
          msg: "You are not in smart mode",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 1
      );
      Navigator.of(context).push(new MyHomePageroute());
    }

  });
}
void  logouttap(BuildContext context) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("ip", ip + "," + "0" + "," + user + "," + pass);
  session="0";
  Navigator.of(context).push(new logoutroute());
}
void augmentedapp() async
{
  if(mode=="1")
  {
    bool isInstalled = await DeviceApps.isAppInstalled('com.scet.sahil');
    if(isInstalled)
    {
      Fluttertoast.showToast(
          msg: "Lanching AR app...",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 1
      );
      Future.delayed(const Duration(milliseconds:700), ()
      {
        DeviceApps.openApp('com.scet.sahil');
      });
    }
    else
    {
      Fluttertoast.showToast(msg: "Unity app is not installed");
    }


  }
  else {
    Fluttertoast.showToast(
        msg: "You are not in smart mode",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1
    );

  }

}

void configtap(BuildContext context)
{
  Navigator.of(context).push(new configroute());
}
class change_username extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new change_username_state();
  }
}

class change_username_state extends State<change_username> with TickerProviderStateMixin {
  void changeusername() async
  {
    if(username.text=="" && confirm_username.text=="")
      Fluttertoast.showToast(msg: "You can not left this field null");
    else if(username.text==confirm_username.text)
    {
      Navigator.of(context).push(new logoutroute());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("ip", ip + "," + "0" + "," + username.text + "," + pass);
      user=username.text;
      Fluttertoast.showToast(msg: "Username changed successfully");
    }
    else
      Fluttertoast.showToast(msg: "Please enter same username in both fields");
  }

  TextEditingController username = new TextEditingController();
  TextEditingController confirm_username = new TextEditingController();
  Widget build(BuildContext bc)
  {

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/main.jpg"),
              fit: BoxFit.cover,
              color: Color(0000000).withOpacity(0.90),
              colorBlendMode: BlendMode.darken,

            ),
//            new AnimatedBackground(
//              behaviour: animation,
//              vsync: this,
//              child: new Text(""),
//            ),
            new Center(

              child: new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //new Image.asset('assets/Manual.png',width: 100,height: 82,fit: BoxFit.fill,color: Colors.white,),
                      new Icon(MdiIcons.accountConvert,size: 100,color: Colors.white,),

                      new Padding(padding: EdgeInsets.only(bottom: 50)),
                      new Container(
                        child: new Form(
                          child: Column(
                            children: <Widget>[
                              new SizedBox(
                                width: 300,
                                child:new TextField(
                                  controller: username,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
//                                icon:Icon(Icons.account_box,color: Colors.white,),
                                      prefixIcon: Icon(Icons.supervised_user_circle,color: Colors.white,),
                                      hintText: "New Username",

                                      hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                                  ),
                                  style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),
                                  obscureText: true,

                                ),
                              ),
                              new Padding(padding:EdgeInsets.all(20)),
                              new SizedBox(
                                width: 300,
                                child:new TextField(
                                  controller: confirm_username,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon:Icon(Icons.supervised_user_circle,color: Colors.white,),
                                      hintText: "Confirm Username",
                                      hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                                  ),
                                  style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),
                                  obscureText: true,

                                ),
                              ),
                              new Padding(padding:EdgeInsets.all(20)),
                              new SizedBox(
                                width: 300,
                                child:  new MaterialButton(
                                    splashColor: Colors.deepOrange,
                                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                                  child: Text("Change username",style:TextStyle(color:Colors.black,fontSize:25,fontFamily: 'po',fontWeight: FontWeight.bold),),
                                  shape: new CircleBorder(),
                                  color: Colors.white,
                                  onPressed: () {
                                    changeusername();
                                  },
                                ),
                              ),
                              new Padding(padding:EdgeInsets.all(20)),

                            ],
                          ),
                        ),
                      )
                    ],)
                ],
              ),
            ),


          ],
        )

    );
  }
}
class change_password extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new change_password_state();
  }
}

class change_password_state extends State<change_password> with TickerProviderStateMixin{
  void changepassword() async
  {

    if(password.text=="" && confirm_password.text=="")
      Fluttertoast.showToast(msg: "You can not left this field null");
    else if(password.text==confirm_password.text) {
      Navigator.of(context).push(new logoutroute());
      pass=password.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("ip", ip + "," + "0" + "," + user + "," + password.text);
      Fluttertoast.showToast(msg: "password changed successfully");
    }
    else
      Fluttertoast.showToast(msg: "Please enter same password in both fields");
  }

  TextEditingController password = new TextEditingController();
  TextEditingController confirm_password = new TextEditingController();
  Widget build(BuildContext bc)
  {

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/main.jpg"),
              fit: BoxFit.cover,
              color: Color(0000000).withOpacity(0.90),
              colorBlendMode: BlendMode.darken,

            ),
//            new AnimatedBackground(
//              behaviour: animation,
//              vsync: this,
//              child: new Text(""),
//            ),
            new Center(
              child: new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //new Image.asset('assets/Manual.png',width: 100,height: 82,fit: BoxFit.fill,color: Colors.white,),
                    new Icon(MdiIcons.accountKeyOutline,size: 100,color: Colors.white,),

                    new Padding(padding: EdgeInsets.only(bottom: 50)),
                    new Container(
                      child: new Form(
                        child: Column(
                          children: <Widget>[
                            new SizedBox(
                              width: 300,
                              child:new TextField(
                                controller: password,
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
//                                icon:Icon(Icons.account_box,color: Colors.white,),
                                    prefixIcon: Icon(MdiIcons.lockReset,color: Colors.white,),
                                    hintText: "New password",

                                    hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                                ),
                                style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),
                                obscureText: true,

                              ),
                            ),
                            new Padding(padding:EdgeInsets.all(20)),
                            new SizedBox(
                              width: 300,
                              child:new TextField(
                                controller: confirm_password,
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon:Icon(MdiIcons.lockReset,color: Colors.white,),
                                    hintText: "Confirm password",
                                    hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                                ),
                                style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),
                                obscureText: true,

                              ),
                            ),
                            new Padding(padding:EdgeInsets.all(20)),
                            new SizedBox(
                              width: 300,
                              child:  new MaterialButton(
                                splashColor: Colors.deepOrange,
                                padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                                child: Text("Change password",style:TextStyle(color:Colors.black,fontSize:25,fontFamily: 'po',fontWeight: FontWeight.bold),),
                                shape: new CircleBorder(),
                                color: Colors.white,
                                onPressed: () {
                                  changepassword();
                                },
                              ),
                            ),
                            new Padding(padding:EdgeInsets.all(20)),

                          ],
                        ),
                      ),
                    )
                  ],)],
              ),
            )

          ],
        )

    );
  }
}
class usernamepage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _usernamepage();
  }
}
class _usernamepage extends State<usernamepage> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Center(child:new Text('smARt',style: TextStyle(fontFamily:'po',fontSize: 40),)),

        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),

                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),

              ],
            )
        ),
        body:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/main.jpg"),
                fit: BoxFit.fitHeight,
                color: Color(0000000).withOpacity(0.90),
                colorBlendMode: BlendMode.darken,),
//              new AnimatedBackground(
//                behaviour: animation,
//                vsync: this,
//                child: new Text(""),
//              ),
              new change_username(),


            ]
        )
    );
  }
}
class passwordpage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _passwordpage();
  }
}
class _passwordpage extends State<passwordpage> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Center(child:new Text('smARt',style: TextStyle(fontFamily:'po',fontSize: 40),)),

        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),

                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),
              ],
            )
        ),
        body:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/main.jpg"),
                fit: BoxFit.fitHeight,
                color: Color(0000000).withOpacity(0.90),
                colorBlendMode: BlendMode.darken,),
//              new AnimatedBackground(
//                behaviour: animation,
//                vsync: this,
//                child: new Text(""),
//              ),
              new change_password(),


            ]
        )
    );
  }
}
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  @override
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
  Widget build(BuildContext context) {
    return  new WillPopScope(
        onWillPop:_onWillPop,
        child:Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Center(child:new Text('smARt',style: TextStyle(fontFamily:'po',fontSize: 40),)),

        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),

                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),

                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),
              ],
            )
        ),
        body:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/main.jpg"),
                fit: BoxFit.fitHeight,
                color: Color(0000000).withOpacity(0.90),
                colorBlendMode: BlendMode.darken,),
//              new AnimatedBackground(
//                behaviour: animation,
//                vsync: this,
//                child: new Text(""),
//              ),
              new auto_manual_switch(false),


            ]
        )
    ));
  }
}
class hardware extends StatefulWidget {

  @override
  hardwarepage createState() => new hardwarepage();
}
class hardwarepage extends State<hardware> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),

              ],
            )
        ),
        body:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/main.jpg"),
                fit: BoxFit.fitHeight,
                color: Color(0000000).withOpacity(0.90),
                colorBlendMode: BlendMode.darken,),
//              new AnimatedBackground(
//                behaviour: animation,
//                vsync: this,
//                child: new Text(""),
//              ),
              new device_page()


            ]
        )
    );
  }
}
class smartmode extends StatefulWidget {

  @override
  smartmodepage createState() => new smartmodepage();
}
class smartmodepage extends State<smartmode> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40))),

        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),

              ],
            )
        ),
        body:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/main.jpg"),
                fit: BoxFit.fitHeight,
                color: Color(0000000).withOpacity(0.90),
                colorBlendMode: BlendMode.darken,),
//              new AnimatedBackground(
//                behaviour: animation,
//                vsync: this,
//                child: new Text(""),
//              ),
              new Text("smart modes")


            ]
        )
    );
  }
}
class weather extends StatefulWidget {

  @override
  weatherpage createState() => new weatherpage();
}
class weatherpage extends State<weather> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40))),

        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),

              ],
            )
        ),
        body:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/main.jpg"),
                fit: BoxFit.fitHeight,
                color: Color(0000000).withOpacity(0.90),
                colorBlendMode: BlendMode.darken,),
//              new AnimatedBackground(
//                behaviour: animation,
//                vsync: this,
//                child: new Text(""),
//              ),
              new Text("weather")


            ]
        )
    );
  }
}
class config extends StatefulWidget {

  @override
  configpage createState() => new configpage();
}
class configpage extends State<config> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40))),

        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),

              ],
            )
        ),
        body:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/main.jpg"),
                fit: BoxFit.cover,
                color: Color(0000000).withOpacity(0.90),
                colorBlendMode: BlendMode.darken,),
//              new AnimatedBackground(
//                behaviour: animation,
//                vsync: this,
//                child: new Text(""),
//              ),
              new changeip()


            ]
        )
    );
  }
}
class auto_manual_switch extends StatefulWidget
{
  final bool word;
  auto_manual_switch(this.word);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return auto_manual_state();
  }
}
class auto_manual_state extends State<auto_manual_switch> with TickerProviderStateMixin
{
  String mode1;
  auto_manual_state()
  {
    mode1="error";
    word=false;
  }
  Future<String> setjson(String data) async
  {
    var response = await http.get("http://"+ip+"/smart/setmode.php?mode="+data);
    return "done";
  }
  Future<String> getjson() async
  {
    String data;
    data="nothing";
    try
    {
      var response = await http.get("http://"+ip+"/smart/getmode.php");
      if(response.statusCode==200)
      {
        data=response.body;
        mode=data;
        if(data=="1")
        {
          mode1="Auto";
          word=true;
        }
        else if(data=="0")
        {
          mode1="Manual";
          word=false;
        }
        return "done";
      }
      else
      {
        mode="0";
        mode1="error";
        return "not done";
      }
    }
    catch(e)
    {
      mode="0";
      mode1="error";
      word=false;
    }
  }
  void _onChanged1(bool value)
  {
    setjson(value.toString());
    setState(() => word = value);
  }
  bool word;
  Timer timer;
  int n;
  @override
  void didUpdateWidget(auto_manual_switch oldWidget) {
    if (oldWidget.word != widget.word) {
      word = widget.word;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    word = widget.word;

    timer = new Timer.periodic(new Duration(milliseconds:500), (Timer timer) {
      setState(() {
        getjson();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Mode",style: TextStyle(fontSize: 40,fontFamily: 'po'),),
        new Padding(padding: EdgeInsets.all(10)),
        new SizedBox(
          child: new Image(image: AssetImage("assets/"+mode1+".png"),color: Colors.white,),
          width: 200,
          height: 200,
        ),
        new SizedBox(
          width: 70,
          child: new Switch(value:word,
            onChanged:_onChanged1,
          ),
        ),
      ],
    );
  }
}

class changeip extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return changeip_state();
  }
}
class changeip_state extends State<changeip> with TickerProviderStateMixin
{
  TextEditingController password1 = new TextEditingController();

  _showDialog(String password) async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                controller: password1,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    prefixIcon:Icon(Icons.lock,color: Colors.black,),
                    hintText: "Password",
                    hintStyle:TextStyle(color:Colors.black,fontSize:30,fontFamily: 'po')
                ),
                style: TextStyle(color:Colors.black,fontSize:30,fontFamily: 'po'),
                obscureText: true,
              ),
            )
          ],
        ),
        actions: <Widget>[


          new FlatButton(

              child: const Text('Open Connection',style:  TextStyle(color:Colors.black,fontSize:20,fontFamily:'po',fontWeight:FontWeight.bold),),
              onPressed: () {
                  if(password==password1.text)
                    {
                      //Navigator.of(context).pop();
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).push(new MyHomePageroute());
                      setState((){lip=ip;});
                    }
                    else
                      {
                        Fluttertoast.showToast(msg: "Incorrect Password");
                      }


              })
//           new Row(mainAxisAlignment: MainAxisAlignment.center,children:<Widget>[
//
//             IconButton(icon: new Icon(MdiIcons.doorOpen,), onPressed: null,iconSize: 40,color: Colors.white,splashColor: Colors.deepOrange,highlightColor:
//               Colors.orange,disabledColor: Colors.white,),
//           ] )
        ],
      ),
    );
  }
  String lip;
  changeip_state()
  {
    lip=ip;
  }
  var textip=TextEditingController();
  @override
  void changeip(String ip1) async
  {

    var response = await http.get("http://"+ip1+"/smart/getpass.php");
    if(response.statusCode==200)
    {
      String password=response.body;
      _showDialog(password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("ip",ip1+","+session+","+user+","+pass);
      ip=ip1;
      lip=ip1;
      mode="1";
    }
    else
      {
        //Fluttertoast.showToast(msg: "Can not connect to this ip",toastLength: Toast.LENGTH_LONG);
        mode="0";
      }
//    Navigator.of(context).push(new MyHomePageroute());
//    setState((){lip=ip;});

  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                width: 400,
                child:new TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  controller: textip,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText:"Ip Address",
                      hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                  ),
                  style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),

                ),
              ),
              new Padding(padding:EdgeInsets.all(30)),
              new SizedBox(
                child: new Image(
                  image: new AssetImage("assets/ip.png"),
                  fit: BoxFit.fitHeight,
                  color: Colors.white,

                ),
                width: 150,
                height: 150,
              ),
              new Padding(padding:EdgeInsets.all(30)),


              new SizedBox(
                width: 200,
                child:  new MaterialButton(
                  splashColor: Colors.deepOrange,
                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                  child: Text("Change ip",style:TextStyle(color:Colors.black,fontSize:30,fontFamily: 'po',fontWeight: FontWeight.bold),),
                  shape: new CircleBorder(),
                  color: Colors.white,
                  onPressed:()=>changeip(textip.text),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
class device_page_widget extends StatefulWidget
{
  String device;
  device_page_widget(this.device);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return device_page_widget1(this.device);
  }
}

class device_page_widget1  extends State<device_page_widget> with TickerProviderStateMixin
{
  String device;
  device_page_widget1(this.device);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(device=="tubelight")
    {
      if(tubelight.length!=0) {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),
            drawer: new Drawer(
                child: new ListView(
                  children: <Widget> [
                    new DrawerHeader(
                        child:new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(padding:EdgeInsets.all(10)),
                            new Icon(MdiIcons.homeCircle,size: 70,)
                          ],
                        )
                    ),
                    new ListTile(
                      title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        switch_modetap(context);
                      },
                      trailing:new Icon(MdiIcons.homeHeart),
                    ),
                    new ListTile(
                      title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        hardwaretap(context);
                      },
                      trailing:new Icon(Icons.account_balance),
                    ),
                    new ListTile(
                      title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        smartmodetap(context);
                      },
                      trailing:new Icon(Icons.fiber_smart_record,),
                    ),

                    new ListTile(
                      title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(Icons.settings,),
                      onTap: () {
                        configtap(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.accountConvert),
                      onTap: () {
                        chnguser(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.lockReset),
                      onTap: () {
                        chngpass(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.augmentedReality),
                      onTap: () {
                        augmentedapp();
                      },
                    ),
                    new ListTile(
                      title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.logout),
                      onTap: () {
                        logouttap(context);
                      },
                    ),
                  ],
                )
            ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new tubelight_list()


                ]
            )
        );
      }
      else
      {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),
            drawer: new Drawer(
                child: new ListView(
                  children: <Widget> [
                    new DrawerHeader(
                        child:new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(padding:EdgeInsets.all(10)),
                            new Icon(MdiIcons.homeCircle,size: 70,)
                          ],
                        )
                    ),
                    new ListTile(
                      title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        switch_modetap(context);
                      },
                      trailing:new Icon(MdiIcons.homeHeart),
                    ),
                    new ListTile(
                      title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        hardwaretap(context);
                      },
                      trailing:new Icon(Icons.account_balance),
                    ),
                    new ListTile(
                      title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        smartmodetap(context);
                      },
                      trailing:new Icon(Icons.fiber_smart_record,),
                    ),

                    new ListTile(
                      title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(Icons.settings,),
                      onTap: () {
                        configtap(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.accountConvert),
                      onTap: () {
                        chnguser(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.lockReset),
                      onTap: () {
                        chngpass(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.augmentedReality),
                      onTap: () {
                        augmentedapp();
                      },
                    ),
                    new ListTile(
                      title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.logout),
                      onTap: () {
                        logouttap(context);
                      },
                    ),
                  ],
                )
            ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.close,size: 250,),
                        new Text("No Devices Available",style: TextStyle(fontSize: 30,fontFamily: 'po'),)
                      ],
                    ),
                  ),


                ]
            )
        );
      }
    }
    else if(device=="fan")
    {
      if(fan.length!=0) {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),
            drawer: new Drawer(
                child: new ListView(
                  children: <Widget> [
                    new DrawerHeader(
                        child:new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(padding:EdgeInsets.all(10)),
                            new Icon(MdiIcons.homeCircle,size: 70,)
                          ],
                        )
                    ),
                    new ListTile(
                      title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        switch_modetap(context);
                      },
                      trailing:new Icon(MdiIcons.homeHeart),
                    ),
                    new ListTile(
                      title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        hardwaretap(context);
                      },
                      trailing:new Icon(Icons.account_balance),
                    ),
                    new ListTile(
                      title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        smartmodetap(context);
                      },
                      trailing:new Icon(Icons.fiber_smart_record,),
                    ),

                    new ListTile(
                      title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(Icons.settings,),
                      onTap: () {
                        configtap(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.accountConvert),
                      onTap: () {
                        chnguser(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.lockReset),
                      onTap: () {
                        chngpass(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.augmentedReality),
                      onTap: () {
                        augmentedapp();
                      },
                    ),
                    new ListTile(
                      title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.logout),
                      onTap: () {
                        logouttap(context);
                      },
                    ),
                  ],
                )
            ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new fan_list()


                ]
            )
        );
      }
      else
      {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),

                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),
              ],
            )
        ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.close,size: 250,),
                        new Text("No Devices Available",style: TextStyle(fontSize: 30,fontFamily: 'po'),)
                      ],
                    ),
                  ),


                ]
            )
        );
      }
    }
    else if(device=="ac")
    {
      if(ac.length!=0) {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),
            drawer: new Drawer(
                child: new ListView(
                  children: <Widget> [
                    new DrawerHeader(
                        child:new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(padding:EdgeInsets.all(10)),
                            new Icon(MdiIcons.homeCircle,size: 70,)
                          ],
                        )
                    ),
                    new ListTile(
                      title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        switch_modetap(context);
                      },
                      trailing:new Icon(MdiIcons.homeHeart),
                    ),
                    new ListTile(
                      title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        hardwaretap(context);
                      },
                      trailing:new Icon(Icons.account_balance),
                    ),
                    new ListTile(
                      title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        smartmodetap(context);
                      },
                      trailing:new Icon(Icons.fiber_smart_record,),
                    ),

                    new ListTile(
                      title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(Icons.settings,),
                      onTap: () {
                        configtap(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.accountConvert),
                      onTap: () {
                        chnguser(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.lockReset),
                      onTap: () {
                        chngpass(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.augmentedReality),
                      onTap: () {
                        augmentedapp();
                      },
                    ),
                    new ListTile(
                      title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.logout),
                      onTap: () {
                        logouttap(context);
                      },
                    ),
                  ],
                )
            ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new ac_list()


                ]
            )
        );
      }
      else
      {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),

                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),
              ],
            )
        ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.close,size: 250,),
                        new Text("No Devices Available",style: TextStyle(fontSize: 30,fontFamily: 'po'),)
                      ],
                    ),
                  ),


                ]
            )
        );
      }
    }
    else if(device=="tv")
    {
      if(tv.length!=0) {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),
            drawer: new Drawer(
                child: new ListView(
                  children: <Widget> [
                    new DrawerHeader(
                        child:new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(padding:EdgeInsets.all(10)),
                            new Icon(MdiIcons.homeCircle,size: 70,)
                          ],
                        )
                    ),
                    new ListTile(
                      title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        switch_modetap(context);
                      },
                      trailing:new Icon(MdiIcons.homeHeart),
                    ),
                    new ListTile(
                      title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        hardwaretap(context);
                      },
                      trailing:new Icon(Icons.account_balance),
                    ),
                    new ListTile(
                      title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      onTap: () {
                        smartmodetap(context);
                      },
                      trailing:new Icon(Icons.fiber_smart_record,),
                    ),

                    new ListTile(
                      title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(Icons.settings,),
                      onTap: () {
                        configtap(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.accountConvert),
                      onTap: () {
                        chnguser(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.lockReset),
                      onTap: () {
                        chngpass(context);
                      },
                    ),
                    new ListTile(
                      title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.augmentedReality),
                      onTap: () {
                        augmentedapp();
                      },
                    ),
                    new ListTile(
                      title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                      trailing:new Icon(MdiIcons.logout),
                      onTap: () {
                        logouttap(context);
                      },
                    ),
                  ],
                )
            ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new tv_list()


                ]
            )
        );
      }
      else
      {
        return Scaffold
          (
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Center(child:new Text('smARt',style: TextStyle(fontFamily: 'po',fontSize: 40),)),

            ),drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding:EdgeInsets.all(10)),
                        new Icon(MdiIcons.homeCircle,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Home ',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(MdiIcons.homeHeart),
                ),
                new ListTile(
                  title: new Text('Hardware Lab',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    hardwaretap(context);
                  },
                  trailing:new Icon(Icons.account_balance),
                ),
                new ListTile(
                  title: new Text('Smart modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    smartmodetap(context);
                  },
                  trailing:new Icon(Icons.fiber_smart_record,),
                ),

                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Username',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.accountConvert),
                  onTap: () {
                    chnguser(context);
                  },
                ),
                new ListTile(
                  title: new Text('Change Password',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.lockReset),
                  onTap: () {
                    chngpass(context);
                  },
                ),
                new ListTile(
                  title: new Text('Open Unity App',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.augmentedReality),
                  onTap: () {
                    augmentedapp();
                  },
                ),
                new ListTile(
                  title: new Text('Log out',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(MdiIcons.logout),
                  onTap: () {
                    logouttap(context);
                  },
                ),
              ],
            )
        ),
            body:  new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/main.jpg"),
                    fit: BoxFit.fitHeight,
                    color: Color(0000000).withOpacity(0.90),
                    colorBlendMode: BlendMode.darken,),
//                  new AnimatedBackground(
//                    behaviour: animation,
//                    vsync: this,
//                    child: new Text(""),
//                  ),
                  new Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.close,size: 250,),
                        new Text("No Devices Available",style: TextStyle(fontSize: 30,fontFamily: 'po'),)
                      ],
                    ),
                  ),


                ]
            )
        );
      }
    }
  }
}
class device_page_widgetroute extends CupertinoPageRoute {
  String data;
  device_page_widgetroute(this.data)
      : super(builder: (BuildContext context) => new device_page_widget(data));


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new device_page_widget(data));
  }
}
void fan_page(BuildContext c)
{

  Navigator.of(c).push(new device_page_widgetroute("fan"));
}
void tubelight_page(BuildContext c)
{
  Navigator.of(c).push(new device_page_widgetroute("tubelight"));
}
void ac_page(BuildContext c)
{
  Navigator.of(c).push(new device_page_widgetroute("ac"));
}
void tv_page(BuildContext c)
{
  Navigator.of(c).push(new device_page_widgetroute("tv"));
}
class device_page extends StatelessWidget
{
  Widget buildtv(BuildContext context)
  {
    if(tvs=="")
    {
      return Text("");
    }
    else
    {
      return new Container(

        padding: EdgeInsets.all(20),

        child:new MaterialButton(
            splashColor: Colors.deepOrange,
          //            shape: new OutlineInputBorder(borderSide: BorderSide(color:Colors.white,width: 10,style: BorderStyle.solid)),
            onPressed: ()=>tv_page(context),
            child:new Column(
              children: <Widget>[
                new Text("TV ",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 40,fontFamily: 'po',color: Colors.white),),
                new Padding(padding: EdgeInsets.all(20)),
                new Image.asset('assets/tvs.png',fit: BoxFit.fill,color: Colors.white,height:200),
              ],
            )
        ),
      );
    }
  }
  Widget buildac(BuildContext context)
  {
    if(acs=="")
    {
      return Text("");
    }
    else
    {
      return new Container(
          padding: EdgeInsets.all(20),

          child:new MaterialButton(
              splashColor: Colors.deepOrange,
              onPressed: ()=>ac_page(context),
              child:new Column(
                children: <Widget>[
                  new Text("AC ",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 40,fontFamily: 'po',color: Colors.white),),
                  new Padding(padding: EdgeInsets.all(20)),
                  new Image.asset('assets/ac.png',fit: BoxFit.fill,color: Colors.white,height:200),
                ],
              )
          ));
    }
  }
  Widget buildfan(BuildContext context)
  {
    if(fans=="")
    {
      return Text("");
    }
    else
    {
      return new Container(
          padding: EdgeInsets.all(20),

          child:new MaterialButton(
              splashColor: Colors.deepOrange,
              onPressed: ()=>fan_page(context),
              child:new Column(
                children: <Widget>[

                  new Text("Fan ",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 40,fontFamily: 'po',color: Colors.white),),
                  new Padding(padding: EdgeInsets.all(20)),
                  new Image.asset('assets/fan.png',fit: BoxFit.fill,color: Colors.white,height: 200,),
                ],
              )
          ));
    }

  }
  Widget buildtubelight(BuildContext context)
  {
    if(tubelights=="")
    {
      return new Text("");
    }
    else
    {
      return new Container(
          padding: EdgeInsets.all(20),

          child:new MaterialButton(
              splashColor: Colors.deepOrange,
              onPressed: ()=>tubelight_page(context),
              child:new Column(
                children: <Widget>[
                  new Text("Tubelight ",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 40,fontFamily: 'po',color: Colors.white),),
                  new Padding(padding: EdgeInsets.all(20)),
                  new Image.asset('assets/tubelight.png',fit: BoxFit.fill,color: Colors.white,height:200),
                ],
              )
          ));
    }

  }

  Widget build(BuildContext context) {
    // TODO: implement build
//
    return new ListView(
      children: <Widget>[
        buildtubelight(context),
        buildfan(context),
        buildtv(context),
        buildac(context)
      ],
    );
  }
}
class ac_list extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ac_list_state();
  }
}
class ac_list_state extends State<ac_list>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
      reverse: false,
      itemBuilder:(_,int index)=>ac_list_builder(ac[index],index+1),
      itemCount: ac.length,
    );
  }
}
class ac_list_builder extends StatelessWidget
{
  String id;
  int num;
  ac_list_builder(this.id,this.num);
  Widget build(BuildContext context) {
    // TODO: implement build
    return ac_widget(this.id,this.num);
  }
}
class ac_widget extends StatefulWidget
{
  String id;
  int num;
  @override

  ac_widget(this.id,this.num);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ac_widget(this.id,this.num);
  }
}
class _ac_widget extends State<ac_widget>
{
  final temp=new TextEditingController();
  String id;
  int num;
  _ac_widget(this.id,this.num);
  void tempchange(String temp) async
  {
    if(temp=="")
      Fluttertoast.showToast(msg: "You can not left this field null");
    else
      {
        Fluttertoast.showToast(msg: "Temp changed to : "+temp);
        var response = await http.get("http://"+ip+"/smart/ac.php?data=temp&mode=write&value="+temp+"&id="+id);
      }

  }
  void poweron() async
  {
    var response = await http.get("http://"+ip+"/smart/ac.php?data=power&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "power on");
  }
  void poweroff() async
  {
    var response = await http.get("http://"+ip+"/smart/ac.php?data=power_off&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "power off");
  }
  void tempup() async
  {
    var response = await http.get("http://"+ip+"/smart/ac.php?data=temp_up&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "temp up");
  }
  void tempdown() async
  {
    var response = await http.get("http://"+ip+"/smart/ac.php?data=temp_down&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "temp down");
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        decoration: BoxDecoration(

          border: Border.all(
            color: Colors.black,
            width: 0.0,
          ),
        ),
        child:new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(10)),
            new Text("AC "+num.toString(),style: TextStyle(fontSize:40 ,fontFamily: 'po',fontWeight:FontWeight.bold),),
            new Padding(padding:EdgeInsets.all(20)),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Power : ",style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
                    new IconButton(icon: Icon(MdiIcons.powerOff),iconSize:70, onPressed:poweroff,splashColor:Colors.deepOrange,),
                    new IconButton(icon: Icon(MdiIcons.powerStandby),iconSize:70, onPressed:poweron,splashColor:Colors.deepOrange,),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(20)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Temp : ",style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
                    //new IconButton(icon: Icon(MdiIcons.minusBox),iconSize:70, onPressed:tempdown,splashColor:Colors.deepOrange,),
                    //new IconButton(icon: Icon(MdiIcons.plusBox),iconSize:70, onPressed:tempup,splashColor:Colors.deepOrange,)
                      new SizedBox(
                        width: 100,
                        child:new TextField(
                          controller:temp,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
//                                icon:Icon(Icons.account_box,color: Colors.white,),

                              hintText: "18",
                              hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),

                          ),
                          style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),

                        ),
                      ),
                    new IconButton(icon: Icon(MdiIcons.weatherSnowy), onPressed:(){
                      tempchange(temp.text);
                    },iconSize: 50,)
                  ],
                ),
                new Padding(padding: EdgeInsets.all(10)),


              ],
            ),
          ],
        ));
  }
}
class tv_list extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return tv_list_state();
  }
}
class tv_list_state extends State<tv_list>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
      reverse: false,
      itemBuilder:(_,int index)=>tv_list_builder(tv[index],index+1),
      itemCount: tv.length,
    );
  }
}
class tv_list_builder extends StatelessWidget
{
  String id;
  int num;
  tv_list_builder(this.id,this.num);
  Widget build(BuildContext context) {
    // TODO: implement build
    return tv_widget(this.id,this.num);
  }
}
class tv_widget extends StatefulWidget
{
  String id;
  int num;
  @override
  tv_widget(this.id,this.num);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _tv_widget(this.id,this.num);
  }
}
class _tv_widget extends State<tv_widget>
{
  String id;
  int num;
  _tv_widget(this.id,this.num);
  void poweron() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=power&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "power on");
  }
  void poweroff() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=power_off&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "power off");
  }
  void volup() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=volume_up&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "vol up");
  }
  void voldown() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=volume_down&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "vol down");
  }
  void chnlup() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=channel_up&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "chnl up");
  }
  void chnldown() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=channel_down&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "chnl down");
  }
  void muteon() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=mute_on&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "mute on ");
  }
  void muteoff() async
  {
    var response = await http.get("http://"+ip+"/smart/tv.php?data=mute_off&mode=write&value=1&id="+id);
    Fluttertoast.showToast(msg: "mute off");
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(

          border: Border.all(
            color: Colors.black,
            width: 0.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(10)),
            new Text("TV "+num.toString(),style: TextStyle(fontSize:40 ,fontFamily: 'po',fontWeight:FontWeight.bold),),
            new Padding(padding:EdgeInsets.all(20)),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Power : ",style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
                    new IconButton(icon: Icon(MdiIcons.powerOff),iconSize:70, onPressed:poweroff,splashColor:Colors.deepOrange,),
                    new IconButton(icon: Icon(MdiIcons.powerStandby),iconSize:70, onPressed:poweron ,splashColor:Colors.deepOrange,),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(20)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Volume : ",style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
                    new IconButton(icon: Icon(MdiIcons.volumeMinus),iconSize:70, onPressed:voldown ,splashColor:Colors.deepOrange,),
                    new IconButton(icon: Icon(MdiIcons.volumePlus),iconSize:70, onPressed:volup ,splashColor:Colors.deepOrange,)
                  ],
                ),
                new Padding(padding: EdgeInsets.all(20)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Channel : ",style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
                    new IconButton(icon: Icon(MdiIcons.arrowDownBoldCircleOutline),iconSize:70, onPressed:chnldown ,splashColor:Colors.deepOrange,),
                    new IconButton(icon: Icon(MdiIcons.arrowUpBoldCircleOutline),iconSize:70, onPressed:chnlup ,splashColor:Colors.deepOrange,)
                  ],
                ),
                new Padding(padding: EdgeInsets.all(20)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Mute : ",style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
                    new IconButton(icon: Icon(MdiIcons.volumeHigh),iconSize:70, onPressed:muteon ,splashColor:Colors.deepOrange,),
                    new IconButton(icon: Icon(MdiIcons.volumeMute),iconSize:70, onPressed:muteoff ,splashColor:Colors.deepOrange,)
                  ],
                ),
                new Padding(padding: EdgeInsets.all(10))


              ],
            ),

          ],
        )
    );

  }
}
class fan_list extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return fan_list_state();
  }
}
class fan_list_state extends State<fan_list>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
      reverse: false,
      itemBuilder:(_,int index)=>fan_list_builder(fan[index],index+1),
      itemCount: fan.length,
    );
  }
}
class fan_list_builder extends StatelessWidget
{
  String id;
  int num;
  fan_list_builder(this.id,this.num);
  Widget build(BuildContext context) {
    // TODO: implement build
    return fan_widget(this.id,this.num);
  }
}
class fan_widget extends StatefulWidget
{
  String id;
  int num;
  @override
  fan_widget(this.id,this.num);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return fan_widget_state(this.id,this.num);
  }
}
class fan_widget_state extends State<fan_widget>
{
  @override
  String id;
  int num;
  fan_widget_state(this.id,this.num);
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        border: Border.all(
          color: Colors.black,
          width: 0.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          new Padding(padding:EdgeInsets.all(20)),
          new Text("Fan "+num.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
          new Padding(padding: EdgeInsets.all(7)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.fiber_smart_record,),
              new Text("  Status : ",style: TextStyle(fontSize:22,fontFamily: 'po',fontWeight:FontWeight.bold)),
              new SizedBox(
                  width: 70,
                  child:new switch_widget(false,this.id,"fan")
              ),
            ],
          ),
          new Padding(padding:EdgeInsets.all(7)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.shutter_speed),
              new Text("  Speed : ",style: TextStyle(fontSize:22,fontFamily: 'po',fontWeight:FontWeight.bold)),
              new fan_slider(5,this.id,)

            ],
          ),
          new Padding(padding:EdgeInsets.all(20)),
        ],
      ),
    );
  }
}
class switch_widget extends StatefulWidget {
  switch_widget(this.word,this.id,this.switch1);
  final String id;
  final bool word;
  final String switch1;
  int n;
  @override
  State<StatefulWidget> createState() =>
      new _switch_widget(this.id,this.switch1);
}


class _switch_widget extends State<switch_widget>
    with TickerProviderStateMixin {
  String switch1;

  String datadebug="no data";
  Future<String> setjson(String data) async
  {
    if(switch1=="fan")
      var response = await http.get("http://"+ip+"/smart/fan.php?mode=write&id="+id+"&data=status&value="+data);
    else
      var response = await http.get("http://"+ip+"/smart/tubelight.php?mode=write&id="+id+"&data=status&value="+data);
    return "done";
  }
  Future<String> getjson() async
  {
    String data;
    var response;
    if(switch1=="fan")
      response = await http.get("http://"+ip+"/smart/fan.php?mode=read&id="+id+"&data=status");
    else
      response = await http.get("http://"+ip+"/smart/tubelight.php?mode=read&id="+id+"&data=status");
    if(response.statusCode==200)
    {
      data=response.body;
      if(data=="1")
      {
        word=true;
      }
      else if(data=="0")
      {
        word=false;
      }
      return "done";
    }
    else
    {
      Fluttertoast.showToast(
        msg: "You are not in smart mode",
        toastLength: Toast.LENGTH_LONG,

      );
      Navigator.of(context).push(new MyHomePageroute());
      data="0";
      return "not done";
    }
  }
  void _onChanged1(bool value)
  {
    setjson(value.toString());
    setState(() => word = value);
  }

  _switch_widget(this.id,this.switch1);

  bool word;
  Timer timer;
  int n;
  String id;
  @override
  void didUpdateWidget(switch_widget oldWidget) {
    if (oldWidget.word != widget.word) {
      word = widget.word;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    word = widget.word;

    timer = new Timer.periodic(new Duration(milliseconds:500), (Timer timer) {
      setState(() {
        getjson();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return new Switch(value: word,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged:_onChanged1,
    );

  }
}
class fan_slider extends StatefulWidget {
  fan_slider(this.intensity,this.id);
  final String id;
  final double intensity;
  int n;
  @override
  State<StatefulWidget> createState() =>
      new _fan_slider(this.id,this.intensity);
}


class _fan_slider extends State<fan_slider>
    with TickerProviderStateMixin {

  String datadebug="no data";
  Future<String> setjson(String data) async
  {
    var response = await http.get("http://"+ip+"/smart/fan.php?mode=write&id="+id+"&data=speed&value="+data);
    return "done";
  }
  Future<String> getjson() async
  {
    String data;
    var response = await http.get("http://"+ip+"/smart/fan.php?mode=read&id="+id+"&data=speed");
    if(response.statusCode==200)
    {
      data=response.body;
      intensity=double.parse(data);
    }
    else
    {
      Fluttertoast.showToast(
        msg: "You are not in smart mode",
        toastLength: Toast.LENGTH_LONG,

      );
      Navigator.of(context).push(new MyHomePageroute());
      data="0";
      return "not done";
    }
  }
  void _onChanged1(double value)
  {
    setjson(value.toString());
    setState(() => intensity = value);
  }

  _fan_slider(this.id,this.intensity);
  double intensity;
  Timer timer;
  int n;
  String id;
  @override
  void didUpdateWidget(fan_slider oldWidget) {
    if (oldWidget.intensity != widget.intensity) {
      intensity = widget.intensity;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    intensity = widget.intensity;

    timer = new Timer.periodic(new Duration(milliseconds:500), (Timer timer) {
      setState(() {
        getjson();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return new Slider(value: intensity,
      onChanged:_onChanged1,
      min: 0.0,
      max: 5,
      activeColor:Colors.deepOrange,
      inactiveColor:Colors.white,
    );

  }
}
class tubelight_list extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return tubelight_list_state();
  }
}
class tubelight_list_state extends State<tubelight_list>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new ListView.builder(
      reverse: false,
      itemBuilder:(_,int index)=>tubelight_list_builder(tubelight[index],index+1),
      itemCount: tubelight.length,
    );
  }
}
class tubelight_list_builder extends StatelessWidget
{
  String id;
  int num;
  tubelight_list_builder(this.id,this.num);
  Widget build(BuildContext context) {
    // TODO: implement build
    return tubelight_widget(this.id,this.num);
  }
}
class tubelight_widget extends StatefulWidget
{
  String id;
  int num;
  @override
  tubelight_widget(this.id,this.num);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return tubelight_widget_state(this.id,this.num);
  }
}
class tubelight_widget_state extends State<tubelight_widget>
{
  @override
  String id;
  int num;
  tubelight_widget_state(this.id,this.num);
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        border: Border.all(
          color: Colors.black,
          width: 0.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          new Padding(padding:EdgeInsets.all(20)),
          new Text("Tubelight "+num.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontFamily: 'po',fontWeight:FontWeight.bold),),
          new Padding(padding: EdgeInsets.all(7)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.fiber_smart_record,),
              new Text("  Status : ",style: TextStyle(fontSize:22,fontFamily: 'po',fontWeight:FontWeight.bold)),
              new SizedBox(
                  width: 70,
                  child:new switch_widget(false,this.id,"tubelight")
              ),
            ],
          ),
          new Padding(padding:EdgeInsets.all(7)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.wb_sunny),
              new Text("  Intensity : ",style: TextStyle(fontSize:22,fontFamily: 'po',fontWeight:FontWeight.bold)),
              new tubelight_slider(5,this.id,)

            ],
          ),
          new Padding(padding:EdgeInsets.all(20)),
        ],
      ),
    );
  }
}
class tubelight_slider extends StatefulWidget {
  tubelight_slider(this.intensity,this.id);
  final String id;
  final double intensity;
  int n;
  @override
  State<StatefulWidget> createState() =>
      new _tubelight_slider(this.id,this.intensity);
}


class _tubelight_slider extends State<tubelight_slider>
    with TickerProviderStateMixin {

  String datadebug="no data";
  Future<String> setjson(String data) async
  {
    var response = await http.get("http://"+ip+"/smart/tubelight.php?mode=write&id="+id+"&data=intensity&value="+data);
    return "done";
  }
  Future<String> getjson() async
  {
    String data;
    var response = await http.get("http://"+ip+"/smart/tubelight.php?mode=read&id="+id+"&data=intensity");
    if(response.statusCode==200)
    {
      data=response.body;
      intensity=double.parse(data);
    }
    else
    {
      Fluttertoast.showToast(
        msg: "You are not in smart mode",
        toastLength: Toast.LENGTH_LONG,

      );
      Navigator.of(context).push(new MyHomePageroute());
      data="0";
      return "not done";
    }
  }
  void _onChanged1(double value)
  {
    setjson(value.toString());
    setState(() => intensity = value);
  }

  _tubelight_slider(this.id,this.intensity);
  double intensity;
  Timer timer;
  int n;
  String id;
  @override
  void didUpdateWidget(tubelight_slider oldWidget) {
    if (oldWidget.intensity != widget.intensity) {
      intensity = widget.intensity;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    intensity = widget.intensity;

    timer = new Timer.periodic(new Duration(milliseconds:500), (Timer timer) {
      setState(() {
        getjson();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return new Slider(value: intensity,
      onChanged:_onChanged1,
      min: 0.0,
      max: 10,
      activeColor:Colors.deepOrange,
      inactiveColor:Colors.white,
    );

  }
}
  class Bubble {
    /// The position of this bubble.
    Offset position;

    /// The radius of this bubble.
    double radius;

    /// The target radius of this bubble.
    double targetRadius;

    /// The color of this bubble.
    Color color;

    /// The state of the bubble. Is it popping?
    bool popping;
  }

  /// Holds the bubbles configuration information for a [BubblesBehaviour].
  class BubbleOptions {
    /// The total count of bubbles that should be spawned.
    final int bubbleCount;

    /// The minimum radius a bubble should grow to before popping.
    final double minTargetRadius;

    /// The maximum radius a bubble should grow to.
    final double maxTargetRadius;

    /// The growth rate of the bubbles.
    final double growthRate;

    /// The pop rate of the bubbles.
    final double popRate;

    /// Creates a [BubbleOptions] given a set of preferred values.
    ///
    /// Default values are assigned for arguments that are omitted.
    const BubbleOptions({
      this.bubbleCount = 20,
      this.minTargetRadius = 15.0,
      this.maxTargetRadius = 30.0,
      this.growthRate = 5.0,
      this.popRate = 150.0,
    })  : assert(bubbleCount != null),
          assert(minTargetRadius != null),
          assert(maxTargetRadius != null),
          assert(growthRate != null),
          assert(popRate != null),
          assert(bubbleCount >= 0),
          assert(minTargetRadius > 0),
          assert(maxTargetRadius > 0),
          assert(growthRate > 0),
          assert(popRate > 0);

    /// Creates a copy of this [BubbleOptions] but with the given fields
    /// replaced with new values.
    BubbleOptions copyWith({
      int bubbleCount,
      double minTargetRadius,
      double maxTargetRadius,
      double growthRate,
      double popRate,
    }) {
      return BubbleOptions(
        bubbleCount: bubbleCount ?? this.bubbleCount,
        minTargetRadius: minTargetRadius ?? this.minTargetRadius,
        maxTargetRadius: maxTargetRadius ?? this.maxTargetRadius,
        growthRate: growthRate ?? this.growthRate,
        popRate: popRate ?? this.popRate,
      );
    }
  }

  /// Renders bubbles on an [AnimatedBackground].
  class BubblesBehaviour extends Behaviour {
    static math.Random random = math.Random();

    static const double sqrtInverse = 0.707;

    @protected
    List<Bubble> bubbles;
    double deltaTargetRadius;

    /// Called when a bubble pops
    Function(bool wasTap) onPop;

    BubbleOptions _options;

    /// Gets the bubbles options used to configure this behaviour.
    BubbleOptions get options => _options;

    /// Set the bubble options used to configure this behaviour.
    ///
    /// Changing this value will cause the currently spawned bubbles to update.
    set options(BubbleOptions value) {
      assert(value != null);
      if (value == _options) return;
      BubbleOptions oldOptions = _options;
      _options = value;

      onOptionsUpdate(oldOptions);
    }

    /// Creates a new bubbles behaviour.
    ///
    /// Default values will be assigned to the parameters if not specified.
    BubblesBehaviour({
      BubbleOptions options = const BubbleOptions(),
      this.onPop,
    }) : assert(options != null) {
      _options = options;
    }

    @override
    void init() {
      bubbles = generateBubbles(options.bubbleCount);
    }

    /// Generates an amount of bubbles and initializes them.
    ///
    /// This can be used to generate the initial bubbles or new bubbles when
    /// the options change
    @protected
    List<Bubble> generateBubbles(int num) {
      return List<Bubble>.generate(num, (_) {
      Bubble bubble = Bubble();
      _initBubble(bubble);
      return bubble;
      });
    }

    void _initBubble(Bubble bubble) {
      bubble.position = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      var deltaTargetRadius = options.maxTargetRadius - options.minTargetRadius;
      bubble.targetRadius =
          random.nextDouble() * deltaTargetRadius + options.minTargetRadius;

      if (bubble.radius == null) {
        bubble.radius = random.nextDouble() * bubble.targetRadius;
      } else {
        bubble.radius = 0.0;
      }

      bubble.color = HSVColor
          .fromAHSV(
        random.nextDouble() * 0.3 + 0.2,
        random.nextInt(45) * 8.0,
        random.nextDouble() * 0.6 + 0.3,
        random.nextDouble() * 0.6 + 0.3,
      )
          .toColor();
      bubble.popping = false;
    }

    void _popBubble(Bubble bubble, bool wasTap) {
      bubble.popping = true;
      bubble.radius = 0.2 * bubble.targetRadius;
      bubble.targetRadius *= 0.5;
      if (onPop != null)
        onPop(wasTap);
    }

    @override
    void initFrom(Behaviour oldBehaviour) {
      if (oldBehaviour is BubblesBehaviour) {
        bubbles = oldBehaviour.bubbles;

        onOptionsUpdate(oldBehaviour.options);
      }
    }

    /// Called when the behaviour got new options and should update accordingly.
    @protected
    @mustCallSuper
    void onOptionsUpdate(BubbleOptions oldOptions) {
      if (bubbles == null)
        return;
      if (bubbles.length > options.bubbleCount)
        bubbles.removeRange(0, bubbles.length - options.bubbleCount);
      else if (bubbles.length < options.bubbleCount) {
        final int numToSpawn = options.bubbleCount - bubbles.length;
        final newBubbles = generateBubbles(numToSpawn);
        bubbles.addAll(newBubbles);
      }
    }

    @override
    bool get isInitialized => bubbles != null;

    @override
    void paint(PaintingContext context, Offset offset) {
      var canvas = context.canvas;
      Paint paint = Paint()
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (var bubble in bubbles) {
        paint.color = bubble.color;
        if (!bubble.popping) {
          canvas.drawCircle(bubble.position, bubble.radius, paint);
        } else {
          final double radiusSqrt = bubble.radius * sqrtInverse;
          final double targetRadiusSqrt = bubble.targetRadius * sqrtInverse;
          canvas.drawLine(
            bubble.position + Offset(radiusSqrt, radiusSqrt),
            bubble.position + Offset(targetRadiusSqrt, targetRadiusSqrt),
            paint,
          );
          canvas.drawLine(
            bubble.position + Offset(radiusSqrt, -radiusSqrt),
            bubble.position + Offset(targetRadiusSqrt, -targetRadiusSqrt),
            paint,
          );
          canvas.drawLine(
            bubble.position + Offset(-radiusSqrt, radiusSqrt),
            bubble.position + Offset(-targetRadiusSqrt, targetRadiusSqrt),
            paint,
          );
          canvas.drawLine(
            bubble.position + Offset(-radiusSqrt, -radiusSqrt),
            bubble.position + Offset(-targetRadiusSqrt, -targetRadiusSqrt),
            paint,
          );
          canvas.drawLine(bubble.position + Offset(0.0, bubble.radius),
              bubble.position + Offset(0.0, bubble.targetRadius), paint);
          canvas.drawLine(bubble.position + Offset(0.0, -bubble.radius),
              bubble.position + Offset(0.0, -bubble.targetRadius), paint);
          canvas.drawLine(bubble.position + Offset(bubble.radius, 0.0),
              bubble.position + Offset(bubble.targetRadius, 0.0), paint);
          canvas.drawLine(bubble.position + Offset(-bubble.radius, 0.0),
              bubble.position + Offset(-bubble.targetRadius, 0.0), paint);
        }
      }
    }

    @override
    bool tick(double delta, Duration elapsed) {
      if (!isInitialized) return false;
      for (var bubble in bubbles) {
        bubble.radius +=
            delta * (bubble.popping ? options.popRate : options.growthRate);

        if (bubble.radius >= bubble.targetRadius) {
          if (bubble.popping)
            _initBubble(bubble);
          else
            _popBubble(bubble, false);
        }
      }
      return true;
    }

    @override
    Widget builder(
        BuildContext context, BoxConstraints constraints, Widget child) {
      return GestureDetector(
        onTapDown: (details) => _onTap(context, details.globalPosition),
        child: ConstrainedBox(
          // necessary to force gesture detector to cover screen
          constraints: BoxConstraints(
              minHeight: double.infinity, minWidth: double.infinity),
          child: super.builder(context, constraints, child),
        ),
      );
    }

    void _onTap(BuildContext context, Offset globalPosition) {
      RenderBox renderBox = context.findRenderObject();
      var localPosition = renderBox.globalToLocal(globalPosition);
      for (var bubble in bubbles) {
        if ((bubble.position - localPosition).distanceSquared <
            bubble.radius * bubble.radius * 1.2) {
          _popBubble(bubble, true);
        }
      }
    }
  }