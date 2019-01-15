import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
//jnkj
void main()
{
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new app());
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
              new Image.asset('assets/logo.png',width: 100,height: 82,fit: BoxFit.fill,color: Colors.white,),
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
                            onPressed:()=>{},
                          ),
                        ),
                        new Padding(padding:EdgeInsets.all(10)),
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
