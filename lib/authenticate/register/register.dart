import 'package:baathcheeth/firebase/authenticate/auth.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toogle;
  Register({this.toogle});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = new GlobalKey<FormState>();
  String email='';
  String password='';
  String confirmpassword='';
  String name='';
  bool loading = false;
  final Authenticate authenticate = Authenticate();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Register", style: TextStyle(letterSpacing: 1.0),),

          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              label: Text("Login", style: TextStyle(color: Colors.white),),
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: (){
                widget.toogle();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 75,horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: Colors.grey[900],
            child: Container(
              padding: EdgeInsets.all(30),
              child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(
                              color: Colors.grey[500]
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),

                        ),
                        style: TextStyle(
                            color: Colors.white
                        ),
                        validator: (val)=> val.isEmpty? 'Please enter Name': null,
                        onChanged: (val){
                          setState(() {
                            name=val;
                          });
                        }
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                              color: Colors.grey[500]
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),

                        ),
                        style: TextStyle(
                            color: Colors.white
                        ),
                        validator: (val)=> val.isEmpty? 'Please enter valid email': null,
                        onChanged: (val){
                          setState(() {
                            email=val;
                          });
                        }
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Colors.grey[500]
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),

                        ),
                        style: TextStyle(
                            color: Colors.white
                        ),

                        validator: (val)=> val.isEmpty? 'Please enter valid password': null,
                        onChanged: (val){
                          setState(() {
                            password=val;
                          });
                        }
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                              color: Colors.grey[500]
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),

                        ),
                        style: TextStyle(
                            color: Colors.white
                        ),

                        validator: (val)=> val.isEmpty? 'Please enter valid password': null,
                        onChanged: (val){
                          setState(() {
                            confirmpassword=val;
                          });
                        }
                    ),
                    SizedBox(height: 20),
                    loading? Loading(authloading: true,) : FlatButton.icon(
                      icon: Icon( Icons.person),
                      label: Text("Register"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async{
                        if(formkey.currentState.validate()){
                          setState(() {
                            loading = true;
                          });
                          if(confirmpassword == password) {
                            await authenticate.register(name, email, password);
                          }
                          else
                            print("password doesnt match");
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
