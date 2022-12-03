import 'package:flutter/material.dart';

TextStyle TextBold14({Color textColor=Colors.black}){
  return TextStyle(
    fontSize: 14,
    fontFamily: 'Mont-Bold',
    color: textColor,
  );
}

TextStyle TextBold18({Color textColor=Colors.black}){
  return TextStyle(
    fontSize: 18,
    fontFamily: 'Mont-Bold',
    color: textColor,
  );
}

TextStyle TextNormal12({Color textColor=Colors.black}){
  return TextStyle(
    fontSize: 12,
    fontFamily: 'Mont-Regular',
    color: textColor,
  );
}

TextStyle TextNormal18({Color textColor=Colors.black}){
  return TextStyle(
    fontSize: 18,
    fontFamily: 'Mont-Regular',
    color: textColor,
  );
}

LinearGradient TextBgGradeint()
{
  return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black38,
        Colors.black54,
      ]
  );
}