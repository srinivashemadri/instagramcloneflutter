import 'package:baathcheeth/models/arguments.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:flutter/material.dart';

class Following extends StatefulWidget {



  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  List following;

  @override
  Widget build(BuildContext context) {
    Argumentsforfollowing aff = ModalRoute.of(context).settings.arguments;
    following = aff.following;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('${following.length} Following',style: TextStyle(color: Colors.white, letterSpacing: 2.0),),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: following.length,
          itemBuilder: (context,index){
            return Card(
              color: Colors.grey[900],
              child: ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(following[index].profilepicurl),),
                title: Text(following[index].name,style: TextStyle(color: Colors.white),),
                subtitle: Text(following[index].email,style: TextStyle(color: Colors.white),),
                onTap: (){
                  User user = following[index];
                  Searchprofile sp = Searchprofile(user,"Following");
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
