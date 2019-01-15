import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
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
class login extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new loginstate();
  }
}
class loginstate extends State<login> {
  

  void login()
  {
    Fluttertoast.showToast(msg: "Login successfully",toastLength: Toast.LENGTH_SHORT);
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
                        new Padding(padding:EdgeInsets.all(35)),
                        new SizedBox(
                          child:  new MaterialButton(
                            padding: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                            child: Text("Login",style:TextStyle(color:Colors.black,fontSize:40,fontFamily: 'po',fontWeight: FontWeight.bold),),
                            shape: new CircleBorder(),
                            color: Colors.white,
                            onPressed:login,
                          ),
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
