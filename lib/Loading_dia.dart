import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoadingDialog extends StatelessWidget {
  bool spin=false;
  LoadingDialog(this.spin);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(75),
              bottomLeft: Radius.circular(75),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10)
            )
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              CircleAvatar(radius: 55, backgroundColor: Colors.grey.shade400, 
              child: 
             
              SpinKitRotatingCircle(color: Colors.red.shade900,)
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   
                    SizedBox(height: 10.0),
                    Flexible(
                      child: Text(
                        "Loading...",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 20))
                    ),
                    SizedBox(height: 10.0),
                
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}