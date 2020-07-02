import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/arguments.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  List followers;
  @override
  Widget build(BuildContext context) {
    Argumentsforfollowing aff = ModalRoute.of(context).settings.arguments;
    followers = aff.following;
    final curruser = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('${followers.length} Follower(s)',style: TextStyle(color: Colors.white, letterSpacing: 2.0),),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: followers.length,
          itemBuilder: (context,index){
            return Card(
              color: Colors.grey[900],
              child: ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(followers[index].profilepicurl),),
                title: Text(followers[index].name,style: TextStyle(color: Colors.white),),
                subtitle: Text(followers[index].email,style: TextStyle(color: Colors.white),),
                onTap: () async{
                  User user = followers[index];
                  dynamic result = await Database(uid: curruser.uid).isfollowing(user.uid);
                  Searchprofile sp;
                  if(result == true)
                    sp = Searchprofile(user,"Following");
                  else
                    sp = Searchprofile(user,"Follow");
                  Navigator.pushNamed(context, "/searchprofile", arguments: sp);
                },
              ),
            );
          },


        ),
      ),
    );
  }
}

