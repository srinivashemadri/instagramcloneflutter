import 'dart:collection';

import 'package:baathcheeth/firebase/database/chatdatabase.dart';
import 'package:baathcheeth/models/chatinitiative.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Chatscreen extends StatefulWidget {
  @override
  _ChatscreenState createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  String senderid;
  String recieverid;
  final messageholder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Chatinitiative ci = ModalRoute.of(context).settings.arguments;
    senderid = ci.senderid;
    recieverid = ci.recieverid;
    String message="";
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          leading: CircleAvatar(
            backgroundImage: NetworkImage(ci.recieverprofilepic),
            radius: 14,
          ),
          title: Text(ci.recievername),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: StreamBuilder<Event>(
                stream: Chat(senderid,recieverid).getref().orderByChild("timestamp").onValue,
                builder: (context, snapshot) {
                  if(snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
                    Map data = snapshot.data.snapshot.value;
                    List<Messagemodel> list =[];
                    data.forEach((key, value) {
                      Messagemodel messagemodel = Messagemodel(value["uid"],value["message"],value["timestamp"]);
                      list.add(messagemodel);
                    });
                    Comparator<Messagemodel> sortbytimestamp = (a,b)=> a.timestamp.compareTo(b.timestamp);
                    list.sort(sortbytimestamp);
                    list = list.reversed.toList();
                    return ListView.builder(
                      itemCount: list.length,
                      reverse: true,
                      itemBuilder: (context,index){
                        DateTime dt = DateTime.fromMillisecondsSinceEpoch(  int.parse(list[index].timestamp));
                        bool issender = list[index].uid == senderid? true: false;
                        String s = issender? "Message send ": "Message Recieved ";
                        s=s+"At "+dt.hour.toString()+":"+dt.minute.toString()+" On "+ dt.day.toString() +"/"+ dt.month.toString()+"/"+ dt.year.toString();
                        return Wrap(
                          direction: Axis.horizontal,
                          verticalDirection: VerticalDirection.down,
                          textDirection: issender? TextDirection.rtl : TextDirection.ltr,
                          //alignment: issender ? WrapAlignment.end : WrapAlignment.start,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: issender ? Colors.blue : Colors.grey[900],
                                ),
                                child: Text(
                                  "${list[index].message}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              onLongPress: (){

                                showDialog(context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[900],
                                      title: Text("Message Details",style: TextStyle(color: Colors.white),),
                                      content: Text("${s}",style: TextStyle(color: Colors.white),),
                                      actions: <Widget>[
                                        FlatButton.icon(
                                          icon: Icon(Icons.done, color: Colors.white,),
                                          label: Text("Ok",style: TextStyle(color: Colors.white),),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  }
                                );

                              },
                            ),
                            SizedBox(height: 20,),
                          ],
                        );
                      },
                    );
                  }
                  else if(snapshot.data==null){
                    return Loading();
                  }
                  else{
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Start a chat",style: TextStyle(color: Colors.white,fontSize: 18,letterSpacing: 2.0),),

                    );
                  }
                }
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: TextField(
                            controller: messageholder,
                            decoration: InputDecoration(
                              hintText: "Send a message",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(width: 1,color: Colors.blue),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: (val){
                              message = val;
                            },

                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(Icons.send),
                            color: Colors.blue,
                            iconSize: 28,
                            onPressed: () async{
                              if(message!="") {
                                Messagemodel mm = Messagemodel(senderid,message,DateTime.now().millisecondsSinceEpoch.toString());
                                await Chat(senderid,recieverid).sendmessage(mm);
                                messageholder.clear();
                                message="";
                              }
                              else{
                                Fluttertoast.showToast(msg: "Message can't be empty");
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
