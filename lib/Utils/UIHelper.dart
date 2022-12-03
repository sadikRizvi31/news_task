import 'package:flutter/material.dart';

AppBar appBar(){
  return AppBar(
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Right",style: TextStyle(color: Colors.black,fontFamily: 'Mont-Bold'),),
        Text("Q",style: TextStyle(color: Colors.deepOrange,fontFamily: 'Mont-Bold'),),
        Text(" News",style: TextStyle(color: Colors.black,fontFamily: 'Mont-Bold'),)
      ],
    ),
  );
}