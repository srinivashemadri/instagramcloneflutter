import 'package:baathcheeth/firebase/database/chatdatabase.dart';
import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/chatinitiative.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Chats extends StatefulWidget {

  final List<Chatinitiative> list;
  Chats({this.list});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<Chatinitiative> withwhomchattedlist;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    withwhomchattedlist=[];
    if(widget.list!=null)
      withwhomchattedlist = widget.list;
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Comparator<Chatinitiative> sort= (a,b)=> a.latesttimestamp.compareTo(b.latesttimestamp);
    withwhomchattedlist.sort(sort);
    withwhomchattedlist = withwhomchattedlist.reversed.toList();
    return loading? Loading(): Scaffold(
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
              setState(() {
                loading = true;
              });
              dynamic result = await Database(uid: user.uid).getwithwhomchatted();
              setState(() {
                withwhomchattedlist = result;
                loading= false;
              });
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: withwhomchattedlist.length,
        itemBuilder: (context,index){
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              trailing: Icon(Icons.arrow_forward, color: Colors.white,),
              leading: CircleAvatar(backgroundImage: NetworkImage(withwhomchattedlist[index].recieverprofilepic),),
              title: Text("${withwhomchattedlist[index].recievername}",style: TextStyle(color: Colors.white),),
              subtitle: Text(withwhomchattedlist[index].recieveronlinestatus,style: TextStyle(color: Colors.grey[400])),
              onTap: (){
                Chatinitiative ci = Chatinitiative(
                    recieverprofilepic: withwhomchattedlist[index].recieverprofilepic,
                    recievername: withwhomchattedlist[index].recievername,
                    senderid: user.uid,
                    recieverid: withwhomchattedlist[index].recieverid
                );
                Navigator.pushNamed(context, "/chatscreen", arguments: ci);
              },

            ),
          );
        },
      ),
    );


  }
}
