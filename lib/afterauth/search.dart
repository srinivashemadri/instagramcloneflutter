import 'dart:ui';

import 'package:baathcheeth/afterauth/searchedprofile.dart';
import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchemail;
  bool userexists=false;
  String email;
  String name;
  String uid;
  String followingornot;
  String profilepicurl;
  bool loading = false;

  final Database db = Database();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading? Loading(): userexists? Searchedprofile(profilepicurl: profilepicurl,email: email,name: name,uid: uid,followingornot: followingornot,) : Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              color: Colors.grey[900],
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.grey[900],
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search by email..",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            letterSpacing: 1.0,
                          ),

                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (val){
                          searchemail= val;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.white,),
                      onPressed: () async{
                        setState(() {
                          loading=true;
                        });
                        dynamic result = await db.searchuser(searchemail);
                        setState(() {
                          loading=false;
                        });
                        if(result!= null) {
                          email = result.email;
                          name = result.name;
                          uid = result.uid;
                          profilepicurl = result.profilepicurl;
                          //print("in search.dart profilepicurl ="+ profilepicurl);
                            dynamic fornot = await Database(uid: user.uid).isfollowing(result.uid);
                            if(fornot == true){
                              setState(() {
                                followingornot= "Following";
                              });
                            }
                            else{
                              setState(() {
                                followingornot = "Follow";
                              });
                            }
                          setState(() {
                            userexists= true;
                          });
                        }
                        else{
                          userexists = false;
                          Fluttertoast.showToast(msg: "No user found!",gravity: ToastGravity.CENTER);
                        }
                        },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


    );
  }
}
