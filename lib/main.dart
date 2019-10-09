import 'package:blog_app/Authentication.dart';
import 'package:blog_app/HomePage.dart';
import 'package:blog_app/Mapping.dart';
import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';

void main ()
{
    runApp(new BlogApp());
}

class BlogApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp
    (
      title: "Blog App",

      theme: new ThemeData
      (
        primarySwatch: Colors.green,
      ),

      home: MappingPage(auth: Auth(),),

    );
  }
}