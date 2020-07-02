import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatefulWidget {
  final bool authloading;
  Loading({this.authloading});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return widget.authloading != true? Container(
      color: Colors.black,
      child: SpinKitCircle(
        color: Colors.blue,
      ),
    ) : Container(
      color: Colors.transparent,
      child: SpinKitCircle(
        color: Colors.blue,
      ),
    ) ;
  }
}
