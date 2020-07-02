
import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Home extends StatefulWidget {
  List list;
  Home(List li)
  {
    list = li;
  }

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  List list;
  bool loading = false;


  @override
  void initState()   {
    list= widget.list;

  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    void getpostsdata() async{
      setState(() {
        loading = true;
      });
      dynamic result = await Database(uid: user.uid).userpost(false);
      setState(() {
        loading = false;
      });
      setState(() {
        list = result;
      });
    }
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
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.refresh, color: Colors.white, size: 28,),
            label: Text("Refresh", style: TextStyle(color: Colors.white),),
            onPressed: () async {
              getpostsdata();
            },
          )
        ],
      ),
      body: loading? Loading(): list.length==0? Center(
        child: Text("No posts yet from whom you are following!", style: TextStyle(color: Colors.white,letterSpacing: 1.0,fontSize: 18),),
      ): ListView.builder(
        itemCount: list==null? 0 : list.length ,
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
