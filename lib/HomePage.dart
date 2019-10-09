import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'Mapping.dart';

class HomePage extends StatefulWidget
{

  HomePage
  ({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() 
  {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
{
  void _logoutUser() async
  {
    try
    {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch(e)
    {
      print("Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return new Scaffold
    (
      appBar: new AppBar
      (
        title: new Text("--Home--"),
      ),

    body: new Container
    (

    ),

    bottomNavigationBar: new BottomAppBar
    (
      color: Colors.red,
      child: new Container
      (

        margin: const EdgeInsets.only(left: 50.0, right: 50.0),

        child: new Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,//this will create space beteen buttons in snackbar
          mainAxisSize: MainAxisSize.max,

          children: <Widget>
          [
            new IconButton
            (
              icon: new Icon(Icons.local_car_wash),
              iconSize: 50,
              color: Colors.white,
              onPressed: _logoutUser,
            ),

            new IconButton
            (
              icon: new Icon(Icons.add_a_photo),
              iconSize: 50,
              color: Colors.white,
              onPressed: null,
            )

            
          ],

        ),
      ),
    ),

    );
  }
}