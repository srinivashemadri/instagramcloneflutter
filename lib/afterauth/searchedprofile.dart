import 'package:baathcheeth/afterauth/profile.dart';
import 'package:baathcheeth/afterauth/search.dart';
import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/arguments.dart';
import 'package:baathcheeth/models/chatinitiative.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Searchedprofile extends StatefulWidget {
  final String name;
  final String email;
  final String uid;
  final String profilepicurl;
  final String followingornot;
  Searchedprofile({this.name,this.email,this.uid,this.followingornot,this.profilepicurl});
  @override
  _SearchedprofileState createState() => _SearchedprofileState();
}

class _SearchedprofileState extends State<Searchedprofile> {
  bool backpressed= false;
  bool loading = false;
  String followingornot;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    followingornot = widget.followingornot;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Searchprofile sp = ModalRoute.of(context).settings.arguments;
    User user2 = null;
    if(sp!=null){
      user2 = sp.user;
      followingornot = sp.followingornot;
    }
    if(widget.uid == null){
      if(user.uid == user2.uid){
        return Profile();

      }
    }
    else if(user2 ==null){
      if(user.uid == widget.uid){
       return Profile();
      }
    }
    return backpressed? sp==null? Search(): Profile() : loading? Loading() : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            setState(() {
              backpressed= true;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user2==null ? widget.profilepicurl: user2.profilepicurl),
              radius: 60,
            ),
            SizedBox(height: 20,),
            Text('Name', style: TextStyle(color: Colors.grey[500],letterSpacing: 1.0,fontSize: 18),),
            SizedBox(height: 20,),
            Text(user2==null? '${widget.name}' : '${user2.name}' , style: TextStyle(color: Colors.grey[50], fontSize: 22),),
            SizedBox(height: 40,),
            Text('Email', style: TextStyle(color: Colors.grey[500],letterSpacing: 1.0,fontSize: 18),),
            SizedBox(height: 20,),
            Text(user2==null? '${widget.email}': '${user2.email}' , style: TextStyle(color: Colors.grey[50],fontSize: 22),),
            SizedBox(height: 40,),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Colors.transparent,
                child: FlatButton.icon(
                  label:  Text(followingornot, style: TextStyle(color: Colors.white),),
                  icon: Icon(Icons.people_outline,color: Colors.white,),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25)
                  ),
                  onPressed: () async  {
                      if(followingornot == "Follow") {
                        await Database(uid: user.uid).followuser(user2==null? widget.uid: user2.uid,user2==null? widget.name: user2.name);
                        setState(() {
                          followingornot ="Following";
                          if(user2!=null){
                            setState(() {
                              sp.followingornot = "Following";
                            });
                          }

                        });
                      }
                      else{
                        await Database(uid: user.uid).unfollowuser(user2==null? widget.uid: user2.uid);
                        setState(() {
                          followingornot ="Follow";
                          if(user2!=null){
                            setState(() {
                              sp.followingornot = "Follow";
                            });
                          }
                        });
                      }
                  },
                  color: Colors.blue,
                )
            ),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,

              color: Colors.transparent,
              child: FlatButton.icon(
                color: Colors.blue,
                label:  Text("Message", style: TextStyle(color: Colors.white),),
                icon: Icon(Icons.chat,color: Colors.white,),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25)
                ),
                splashColor: Colors.black,
                onPressed: ()async{
                    Chatinitiative ci = Chatinitiative(
                        recieverprofilepic: user2==null? widget.profilepicurl : user2.profilepicurl ,
                        recievername: user2==null? widget.name: user2.name,
                        senderid: user.uid,
                        recieverid: user2==null? widget.uid : user2.uid
                    );
                    Navigator.pushNamed(context, "/chatscreen", arguments: ci);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
