import 'dart:io';

import 'package:baathcheeth/afterauth/followingdisplay.dart';
import 'package:baathcheeth/firebase/authenticate/auth.dart';
import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/arguments.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Authenticate auth = Authenticate();
   String databasename;
   String databaseemail;
   String databaseprofilepicurl;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final uid = user.uid;
    final formkey = GlobalKey<FormState>();
    bool loading=false;
    File img;

    Future chooseImage() async{
      img= null;
      var tempimg = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 30);
      setState(() {
        img = tempimg;
      });
      if(img!=null) {
        Fluttertoast.showToast(msg: "Profile Pic updating, Please wait",
            textColor: Colors.white,
            backgroundColor: Colors.blue);
        StorageReference ref = await FirebaseStorage.instance.ref().child(
            user.uid).child("profilepic").child("currentprofilepic");
        StorageUploadTask task = await ref.putFile(img);
        var downloadurl = await (await task.onComplete).ref.getDownloadURL();
        print(downloadurl);
        await Database(uid: uid).updateuserdata(
            databasename, databaseemail, downloadurl.toString(),"online");
        Fluttertoast.showToast(msg: "Profile Pic Updated successfully",
            textColor: Colors.white,
            backgroundColor: Colors.green);
      }
    }
    void EditProfile(String name,String email)
    {
      showModalBottomSheet(context: context,isScrollControlled: true,shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0))), builder: (context){
        return loading? Loading(): Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: formkey ,
                  child: Column(
                    children: <Widget>[
                      Text("Edit Profile", style: TextStyle(letterSpacing: 2.0, fontSize: 20, color: Colors.black),),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(
                          hintText: "Name"
                        ),
                        validator: (val)=> val.isEmpty? 'Please enter Name': null,
                        onChanged: (val){
                          name = val;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: email,
                        decoration: InputDecoration(
                            hintText: "Email"
                        ),
                        validator: (val)=> val.isEmpty? 'Please enter Email': null,
                        onChanged: (val){
                          email = val;
                        },
                      ),
                      SizedBox(height: 20,),
                      FlatButton.icon(
                        label: Text("Update Changes", style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.edit, color: Colors.white,),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25)
                        ),
                        onPressed: () async{
                          if(formkey.currentState.validate()){
                            loading=true;
                            await Database(uid: user.uid).updateuserdata(name, email , databaseprofilepicurl,"online");
                            loading=false;
                            Navigator.pop(context);
                          }
                        },
                        color: Colors.blue,


                      ),
                    ],
                  ),
                ),
              ),
            ),

          )
        );
      });
    }
    void changepassword(String email)
    {
      final formkeyforchangepassword = new GlobalKey<FormState>();
      String existpwd;
      String newpwd;
      String newcnfpwd;
      showModalBottomSheet(context: context,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0))),
          isScrollControlled: true,
          builder: (context){
              return loading? Loading() : Container(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
                child: Scaffold(
                  body: Form(
                    key: formkeyforchangepassword,
                    child: Column(

                      children: <Widget>[
                        SizedBox(height: 40,),
                        Text("Change Password",
                          style: TextStyle(
                          letterSpacing: 1.0,
                            color: Colors.black,
                            fontSize: 20
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Current password"
                          ),
                          validator: (val)=> val.isEmpty? "Password shouldn't be empty" : null,
                          onChanged: (val){
                            existpwd = val;
                          },
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "New password"
                          ),
                          validator: (val)=> val.isEmpty? "Password shouldn't be empty" : null,
                          onChanged: (val){
                            newpwd = val;
                          },
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Confirm new password"
                          ),
                          validator: (val)=> val.isEmpty? "Password shouldn't be empty" : null,
                          onChanged: (val){
                            newcnfpwd = val;
                          },
                        ),
                        SizedBox(height: 20,),
                        FlatButton.icon(
                          color: Colors.blue,
                          label: Text("Update password",
                          style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(Icons.edit, color: Colors.white,),
                          onPressed: () async{
                            if(formkeyforchangepassword.currentState.validate()){
                              setState(() {
                                loading=true;
                              });
                              if(newpwd== newcnfpwd){
                                await auth.changepassword(email,existpwd,newpwd);
                                setState(() {
                                  loading= false;
                                });
                                Fluttertoast.showToast(msg: "Password updated successfully");
                                Navigator.pop(context);

                              }
                            }
                          },
                        )

                      ],
                    ),
                  ),
                ),
              );
      });
    }
    return StreamBuilder<User>(
      stream: Database(uid: uid).userdata,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          User user = snapshot.data;
          databaseemail = user.email;
          databasename = user.name;
          databaseprofilepicurl = user.profilepicurl;
          Database(uid: user.uid).updateuserdata(databasename,databaseemail,databaseprofilepicurl,"online");
          return Scaffold(
              backgroundColor: Colors.black,
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                child: Card(
                  color: Colors.black,
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                         CircleAvatar(
                            backgroundImage: databaseprofilepicurl!=null ? NetworkImage(databaseprofilepicurl) : AssetImage("assets/user.png"),
                            backgroundColor: Colors.transparent,
                            radius: 60,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(85,85, 0, 0),
                              child: IconButton(
                                icon: Icon(Icons.camera_alt,color: Colors.blue,) ,
                                iconSize: 32,
                                onPressed:(){
                                  chooseImage();
                                }
                              ),
                            ),
                          ),

                          FlatButton.icon(
                            label: Text("Edit profile", style: TextStyle(letterSpacing: 1.0,color: Colors.yellow),),
                            icon: Icon(Icons.edit, color: Colors.yellow,),
                            onPressed: (){
                              print("Edit profile");
                              EditProfile(user.name,user.email);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                          children: <Widget>[
                            Text('Name', style: TextStyle(color: Colors.grey[500],),),
                            SizedBox(width: 40,),
                            Text('${databasename}', style: TextStyle(color: Colors.grey[50],),)
                          ],
                        ),
                      SizedBox(height: 20,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Email', style: TextStyle(color: Colors.grey[500]),),
                            SizedBox(width: 40,),
                            Text('${databaseemail}', style: TextStyle(color: Colors.grey[50]),)
                          ],
                        ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton.icon(

                            icon: Icon(Icons.camera_alt, color: Colors.white,),
                            label: Text("My posts",style: TextStyle(color: Colors.white),),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)
                            ),
                            onPressed: () async{
                              dynamic result = await Database(uid: user.uid).userpost(true);
                              Posts post = Posts(posts: result);
                              Navigator.pushNamed(context, "/myposts",arguments: post);
                            },
                          ),
                          FlatButton.icon(
                            icon: Icon(Icons.person, color: Colors.white,),
                            label: Text("Followers",style: TextStyle(color: Colors.white),),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20)
                            ),
                            onPressed: () async{
                              dynamic result = await Database(uid: user.uid).getfollowers();
                              Argumentsforfollowing aff = Argumentsforfollowing(following: result);
                              Navigator.pushNamed(context, "/followers", arguments: aff);

                            },
                          ),
                          FlatButton.icon(
                            icon: Icon(Icons.group, color: Colors.white,),
                            label: Text("Following",style: TextStyle(color: Colors.white),),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20)
                            ),
                            onPressed: () async{
                              dynamic result = await Database(uid: user.uid).getfollowing();
                              Argumentsforfollowing aff = Argumentsforfollowing(following: result);
                              Navigator.pushNamed(context, "/following", arguments: aff);

                            },
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Text("-Account Settings-", style: TextStyle(color: Colors.white, letterSpacing: 2.0, fontSize: 20),),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: Colors.transparent,
                        child: FlatButton.icon(
                          label: Text("Change Password", style: TextStyle(color: Colors.white),),
                          icon: Icon(Icons.edit, color: Colors.white,),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25)
                          ),
                          onPressed: (){
                            changepassword(user.email);
                          },
                          color: Colors.blue,


                        ),

                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: Colors.transparent,
                        child: FlatButton.icon(
                          label: Text("Delete my account", style: TextStyle(color: Colors.white),),
                          icon: Icon(Icons.delete, color: Colors.white,),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25)
                          ),
                          onPressed: () async{
                            showDialog(context: context,
                              builder: (BuildContext context){
                              return AlertDialog(
                                backgroundColor: Colors.grey[900],
                                title: Text("Confirm Deleting your account?",style: TextStyle(color: Colors.white)),
                                content: Text("This operation can't be undone! all your posts,chats will be deleted permanently",style: TextStyle(color: Colors.grey[200])),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FlatButton.icon(
                                        icon: Icon(Icons.cancel),
                                        label: Text("Cancel",),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton.icon(
                                        icon: Icon(Icons.delete,color: Colors.red,),
                                        label: Text("Confirm",style: TextStyle(color: Colors.red)),
                                        onPressed: () async{
                                          Fluttertoast.showToast(msg: "Account deletion in progress",textColor: Colors.white, backgroundColor: Colors.yellow);
                                          dynamic result = await auth.deleteaccount(user.uid);
                                          if(result == true){
                                            Fluttertoast.showToast(msg: "Account deleted successfully", backgroundColor: Colors.green, textColor: Colors.white);
                                          }
                                          else{
                                            Fluttertoast.showToast(msg: "This operation is sensitive, Please login again to continue", backgroundColor: Colors.red, textColor: Colors.white);
                                            auth.logout();
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              );
                              }
                            );

                          },
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: Colors.transparent,
                        child: FlatButton.icon(
                          label: Text("Sign Out", style: TextStyle(color: Colors.white),),
                          icon: Icon(Icons.exit_to_app, color: Colors.white,),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25)
                          ),
                          onPressed: () async {
                            DateTime dt = DateTime.now();
                            String stat = "Last seen at "+ dt.hour.toString() +":" + dt.minute.toString() + " On "+ dt.day.toString()+"/"+ dt.month.toString()+"/"+dt.year.toString();
                            auth.logout();
                            await Database(uid: user.uid).updateuserdata(databasename, databaseemail, databaseprofilepicurl, stat);

                          },
                          color: Colors.pinkAccent,
                        )
                      ),
                    ],
                  ),
                ),
              ),

          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
