class Chatinitiative{
  final String senderid;
  final String recieverid;
  final String recieverprofilepic;
  final String recievername;
  final String recieveremailid;
  final String latesttimestamp;
  final String recieveronlinestatus;
  Chatinitiative({this.recieveronlinestatus,this.latesttimestamp,this.recieveremailid,this.recieverid,this.senderid,this.recieverprofilepic,this.recievername});
}

class Messagemodel{
  String uid;
  String message;
  String timestamp;
  Messagemodel(String u,String m, String ts) {
    this.uid = u;
    this.message = m;
    this.timestamp = ts;
  }
}