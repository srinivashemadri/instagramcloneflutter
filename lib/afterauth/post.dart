import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  File img;
  double percentage = 0.0;
  bool uploadclicked = false;

  Future chooseImage() async{
    img= null;
    uploadclicked = false;
    percentage = 0.0;
    var tempimg = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 10 );
    setState(() {
      img = tempimg;

    });
  }
  Widget enableupload(){
    return Container(
      child: Image.file(img, height: 300,width: 300,),
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
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
      )
      ),
      body: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.transparent,
              child: FlatButton.icon(
                label: Text("upload a new file", style: TextStyle(color: Colors.white),),
                icon: Icon(Icons.camera_alt, color: Colors.white,),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25)
                ),
                onPressed: chooseImage,
                color: Colors.blue[200],
              )
          ),
          SizedBox(height: 20,),
          img== null? Text("no file",) : enableupload(),
          SizedBox(height: 20,),
          img!=null? FlatButton.icon(
            icon: Icon(Icons.file_upload, color: Colors.white,),
            label: Text("Upload",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            color: Colors.blue,
            onPressed: () async {
              setState(() {
                uploadclicked=true;
              });
              int ts = DateTime.now().millisecondsSinceEpoch;
              StorageReference ref = await FirebaseStorage.instance.ref().child(user.uid).child(ts.toString());
               StorageUploadTask task = await ref.putFile(img);
               await task.events.listen((event) {
                 double perc = 100 * event.snapshot.bytesTransferred/event.snapshot.totalByteCount;
                 setState(() {
                   percentage = perc;
                 });
               });
               task.onComplete.then((value){

               });
               var downloadurl = await (await task.onComplete).ref.getDownloadURL();
                Fluttertoast.showToast(msg: "Image posted successfully");
                setState(() {
                  Database(uid: user.uid).addpost(downloadurl.toString());
                });
            },
          ) : Container(),
          SizedBox(height: 20,),
          uploadclicked && img!=null ? CircularPercentIndicator(
            radius: 75,
            lineWidth: 7,
            percent: percentage/100,
            center: Text(percentage.floor().toString() + "%", style: TextStyle(color:Colors.white ),),
            progressColor: Colors.blue,
            backgroundColor: Colors.white,
          ): Container(),
        ],
      ),
    );
  }
}
