import 'package:baathcheeth/models/arguments.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Myposts extends StatefulWidget {
  @override
  _MypostsState createState() => _MypostsState();
}

class _MypostsState extends State<Myposts> {
  List list;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Posts posts = ModalRoute.of(context).settings.arguments;
    list = posts.posts;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Baathcheeth",
          style: TextStyle(
              fontFamily: 'Dancingscript',
              fontSize: 26,
              letterSpacing: 1.5
          ),
        ),

      ),
      body: loading? Loading(): ListView.builder(
        itemCount: list.length  ,
        itemBuilder: (context, index){
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            color: Colors.grey[900],
            child: Column(
              children: <Widget>[
                list[index].url!= null ? Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(list[index].profilepicurl)),
                      title: Text(list[index].name, style: TextStyle(color: Colors.white),),
                      subtitle: Text(list[index].datetime ?? "", style: TextStyle(color: Colors.grey[500]),),
                    ),
                    Image.network(list[index].url),
                  ],
                ) : Container(),

              ],

            ),


          );
        },
      ),


    );
  }
}
