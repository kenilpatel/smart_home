import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
String ip="192.168.0.1";
List<String> tv,ac,fan,tubelight;
String tvs,acs,fans,tubelights;
String mode;
DateTime currentBackPressTime = DateTime.now();


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
void main()
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
        body: new home(),

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class forgetpageroute extends CupertinoPageRoute {
  forgetpageroute()
      : super(builder: (BuildContext context) => new forget());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new forget());
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

class loginstate extends State<login> {

  void forget_method()
  {
    Navigator.of(context).push(new forgetpageroute());
  }
  Widget build(BuildContext bc)
  {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
              image: new AssetImage("assets/main.jpg"),
              fit: BoxFit.fitHeight,
              color: Color(0000000).withOpacity(0.90),
              colorBlendMode: BlendMode.darken,

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            new Image.asset('assets/Manual.png',width: 100,height: 82,fit: BoxFit.fill,color: Colors.white,),
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
                            padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                            child: Text("Login",style:TextStyle(color:Colors.black,fontSize:40,fontFamily: 'po',fontWeight: FontWeight.bold),),
                            shape: new CircleBorder(),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).push(new success_loginpageroute());
                            },
                          ),
                        ),
                        new Padding(padding:EdgeInsets.all(20)),
                        new SizedBox(
                          child:InkWell(
                              child: Text("Forget your login details ? Get help signing in",style:TextStyle(color:Colors.white,fontSize:18,fontFamily: 'po',fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                              onTap: forget_method,
                           )

                        )
                      ],
                    ),
                ),
              )
          ],)

        ],
      )

    );
  }
}
class success_loginpageroute extends CupertinoPageRoute {
  success_loginpageroute()
      : super(builder: (BuildContext context) => new home());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new home());
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
class forget extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData.light(),
      home: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new forget_page(),

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class forget_page extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return forget_page_state();
  }
}
class forget_page_state extends State<forget_page>
{
  void back_login()
  {
    Navigator.of(context).push(new loginpageroute());
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/main.jpg"),
              fit: BoxFit.fitHeight,
              color: Color(0000000).withOpacity(0.90),
              colorBlendMode: BlendMode.darken,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Forget Password",style:TextStyle(color:Colors.white,fontSize:50,fontFamily: 'po',fontWeight: FontWeight.bold)),
                new Padding(padding:EdgeInsets.all(40)),
                new SizedBox(
                  width: 300,
                  child:new TextField(
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
//                                icon:Icon(Icons.account_box,color: Colors.white,),
                        prefixIcon: Icon(Icons.email,color: Colors.white,),
                        hintText: "Enter Recovery email",
                        hintStyle:TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po')
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color:Colors.white,fontSize:30,fontFamily: 'po'),

                  ),
                ),
                new Padding(padding:EdgeInsets.all(20)),
                new SizedBox(
                  width: 150,
                  child:  new MaterialButton(
//                    child: Icon(Icons.send,size:50,color: Colors.white,),
                    padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                    child: Text("Send",style:TextStyle(color:Colors.black,fontSize:40,fontFamily: 'po',fontWeight: FontWeight.bold),),
                    shape: new CircleBorder(),
                    color: Colors.white,
                    onPressed:()=>{},
                  ),
                ),
                new Padding(padding:EdgeInsets.all(40)),
                new SizedBox(
                    child:InkWell(
                      child: Text("Back to login",style:TextStyle(color:Colors.white,fontSize:25,fontFamily: 'po',fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                      onTap:back_login,
                    )

                )
              ],
            )
          ],
        )

    );
  }
}
class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData.dark(),
      home: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new MyHomePage(),

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
class  weatherroute extends CupertinoPageRoute {
  weatherroute()
      : super(builder: (BuildContext context) => new weather());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new weather());
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
void  weathertap(BuildContext context)
{
  Navigator.of(context).push(new weatherroute());
}
void configtap(BuildContext context)
{
  Navigator.of(context).push(new configroute());
}
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                        new Icon(Icons.home,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(Icons.autorenew),
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
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
              new auto_manual_switch(false)


            ]
        )
    );
  }
}
class hardware extends StatefulWidget {

  @override
  hardwarepage createState() => new hardwarepage();
}
class hardwarepage extends State<hardware> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                        new Icon(Icons.home,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(Icons.autorenew),
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
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
class smartmodepage extends State<smartmode> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                        new Icon(Icons.home,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(Icons.autorenew),
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
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
class weatherpage extends State<weather> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                        new Icon(Icons.home,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(Icons.autorenew),
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
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
class configpage extends State<config> {

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
                        new Icon(Icons.home,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(Icons.autorenew),
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
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
  String mode;
  auto_manual_state()
  {
    mode="error";
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
        if(data=="1")
        {
          mode="Auto";
          word=true;
        }
        else if(data=="0")
        {
          mode="Manual";
          word=false;
        }
        return "done";
      }
      else
      {
        mode="error";
        return "not done";
      }
    }
    catch(e)
    {
      mode="error";
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
          child: new Image(image: AssetImage("assets/"+mode+".png"),color: Colors.white,),
          width: 200,
          height: 200,
        ),
        new Padding(padding: EdgeInsets.all(30)),
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
void getip() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try
  {
    ip=prefs.get("ip");

  }
  catch(e)
  {

    prefs.setString("ip","192.168.0.1");
    ip=prefs.get("ip");
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
  String lip;
  changeip_state()
  {
    lip=ip;
  }
  var textip=TextEditingController();
  @override
  void changeip(String ip1) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ip",ip1);
    ip=ip1;
    lip=ip1;
    Fluttertoast.showToast(msg: "Ip successfull changed to "+ip,toastLength: Toast.LENGTH_LONG);
    setState((){lip=ip;});
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
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
                hintText:"Ip Adress",
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
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
            child: Text("Change ip",style:TextStyle(color:Colors.black,fontSize:30,fontFamily: 'po',fontWeight: FontWeight.bold),),
            shape: new CircleBorder(),
            color: Colors.white,
            onPressed:()=>changeip(textip.text),
          ),
        ),
      ],
    );
  }
}
class device_page_widget  extends StatelessWidget
{
  String device;
  device_page_widget(this.device);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(device=="tubelight")
    {
      if(tubelight.length!=0) {
        return Scaffold
          (
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
                          new Icon(Icons.home,size: 70,)
                        ],
                      )
                  ),
                  new ListTile(
                    title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                    onTap: () {
                      switch_modetap(context);
                    },
                    trailing:new Icon(Icons.autorenew),
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
                    title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                    trailing:new Icon(Icons.wb_sunny,),
                    onTap: () {
                      weathertap(context);
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
                  new tubelight_list()


                ]
            )
        );
      }
      else
      {
        return Scaffold
          (
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
                          new Icon(Icons.home,size: 70,)
                        ],
                      )
                  ),
                  new ListTile(
                    title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                    onTap: () {
                      switch_modetap(context);
                    },
                    trailing:new Icon(Icons.autorenew),
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
                    title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                    trailing:new Icon(Icons.wb_sunny,),
                    onTap: () {
                      weathertap(context);
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
                          new Icon(Icons.home,size: 70,)
                        ],
                      )
                  ),
                  new ListTile(
                    title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                    onTap: () {
                      switch_modetap(context);
                    },
                    trailing:new Icon(Icons.autorenew),
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
                    title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                    trailing:new Icon(Icons.wb_sunny,),
                    onTap: () {
                      weathertap(context);
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
          new fan_list()


          ]
          )
        );
      }
      else
      {
        return Scaffold
          (
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
                        new Icon(Icons.home,size: 70,)
                      ],
                    )
                ),
                new ListTile(
                  title: new Text('Switch modes',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  onTap: () {
                    switch_modetap(context);
                  },
                  trailing:new Icon(Icons.autorenew),
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
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
  Fluttertoast.showToast(msg: "AC");
}
void tv_page(BuildContext c)
{
  Fluttertoast.showToast(msg: "TV");
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
      data="error";
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
      data="error";
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
      data="error";
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
