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
Future<String> load_devices(String room) async
{
  var response = await http.get("http://"+ip+"/smart/getmode.php");
  mode=response.body.toString();
  if(mode=="1")
  {
    response = await http.get("http://"+ip+"/smart/get_id.php?device=tv&room="+room);
    tvs=response.body.toString();
    response = await http.get("http://"+ip+"/smart/get_id.php?device=ac&room="+room);
    acs=response.body.toString();
    response = await http.get("http://"+ip+"/smart/get_id.php?device=fan&room="+room);
    fans=response.body.toString();
    response = await http.get("http://"+ip+"/smart/get_id.php?device=tubelight&room="+room);
    tubelights=response.body.toString();
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
      home: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new login(),

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class forgetpageroute extends CupertinoPageRoute {
  forgetpageroute()
      : super(builder: (BuildContext context) => new forget());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => home()),
                              );
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
void switch_modetap(BuildContext context)
{
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
}
void hardwaretap(BuildContext context)
{
  load_devices("hardwarelab");
  Future.delayed(const Duration(milliseconds:700), () {
    if(mode=="1")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => hardware()));
    }
    else {
      Fluttertoast.showToast(
        msg: "You are not in smart mode",
        toastLength: Toast.LENGTH_LONG,

      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }

  });
}
void smartmodetap(BuildContext context)
{
  Future.delayed(const Duration(milliseconds:700), () {
    if(mode=="1")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => smartmode()));
    }
    else {
      Fluttertoast.showToast(
          msg: "You are not in smart mode",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 1
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }

  });
}
void  weathertap(BuildContext context)
{
  Navigator.push(context, MaterialPageRoute(builder: (context) => weather()));
}
void configtap(BuildContext context)
{
  Future.delayed(const Duration(milliseconds:700), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => config()));
  });
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20),),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
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
              new Text("hardwarepage")


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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
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
                  title: new Text('Weather',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.wb_sunny,),
                  onTap: () {
                    weathertap(context);
                  },
                ),
                new ListTile(
                  title: new Text('Configuration',style: TextStyle(fontFamily: 'po',fontSize: 20)),
                  trailing:new Icon(Icons.settings,),
                  onTap: () {
                    configtap(context);
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