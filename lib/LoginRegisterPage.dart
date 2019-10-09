import 'dart:ui' as prefix0;

import 'package:blog_app/DialogBox.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';


class LoginRegisterPage extends StatefulWidget
{
  //start - Call back when user 
  LoginRegisterPage
  ({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState()
  {
    return _LoginRegisterState();//Underscore denotes that this class is private
  }
  
}

enum FormType
{
  login,
  register
}

class _LoginRegisterState extends State<LoginRegisterPage>
{
  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  //METHODS
  bool validateAndSave()
  {
    final form = formKey.currentState;

    if(form.validate())
    {
      form.save();
      return true;
    }
    else
    {
      return false;
    }
  }

  void validateAndSubmit() async
  {
    if(validateAndSave())
    {
      try
      {
        if(_formType == FormType.login)
        {
          String userId = await widget.auth.SignIn(_email, _password);
          //dialogBox.information(context, "All Done", "Sucessfully logged in.");
          //print("Login User ID: " + userId);
        }else
        {
          String userId = await widget.auth.SignUp(_email, _password);
          //dialogBox.information(context, "All Done", "Your account has been created successfully.");
         // print("Register User ID: " + userId);
        }

        widget.onSignedIn();
      }catch(e)
      {
        dialogBox.information(context, "Error", e.toString());
        //print("Error: " + e.toString());
      }
    }
  }

  void moveToRegister()
  {
    formKey.currentState.reset();//it will reloab the activity once it is closed

    setState(() 
    {
      _formType = FormType.register;
    });
  }

  void moveToLogin()
  {
    formKey.currentState.reset();//it will reloab the activity once it is closed

    setState(() 
    {
      _formType = FormType.login;
    });
  }


  //USER INTERFACE DESIGN
  @override
  Widget build(BuildContext context) 
  {
    return new Scaffold
    (
      appBar: new AppBar
      (
        title: new Text("6494 - Blog App"),
      ),
      body: new Container
      (
        margin: EdgeInsets.all(15.0),

        child: new Form
        (
          key: formKey,
          child: new Column
          (
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs()
  {
    return
    [
      SizedBox(height: 10.0,), //this will add spacing
      logo(),
      SizedBox(height: 20.0,),

      new TextFormField
      (
        decoration: new InputDecoration(labelText: 'Email'),
        //if email is empty
        validator: (value)
        {
          return value.isEmpty ? 'Please enter Email.' : null;
        },
        //if not empty then assigng the user input email to _email
        onSaved: (value)
        {
          return _email = value;
        },
      ),

      SizedBox(height: 10.0,),

      new TextFormField
      (
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,

         validator: (value)
        {
          return value.isEmpty ? 'Please enter Password.' : null;
        },
        //if not empty then assigng the user input password to _password
        onSaved: (value)
        {
          return _password = value;
        },
      ),

      SizedBox(height: 20.0,),


    ];
  }
  Widget logo()
  {
    return new Hero
    (
      tag: 'hero',
      child: new CircleAvatar
      (
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/logo_blog.png'),
      ),

    );
  }

  List<Widget> createButtons()
  {
    if(_formType == FormType.login)
    {
      return
        [
          new RaisedButton
          (
            child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
            textColor: Colors.white,
            color: Colors.green,

            onPressed: validateAndSubmit,
          ),

          new FlatButton
          (
            child: new Text("Don't have an Account? Register here.", style: new TextStyle(fontSize: 14.0)),
            textColor: Colors.green,

            onPressed: moveToRegister,
            
          ),

          
        ];
    }else //button widget for registration activity
    {
      return
        [
          new RaisedButton
          (
            child: new Text("Register", style: new TextStyle(fontSize: 20.0)),
            textColor: Colors.white,
            color: Colors.green,

            onPressed: validateAndSubmit,
          ),

          new FlatButton
          (
            child: new Text("Already have an Account? Login here.", style: new TextStyle(fontSize: 14.0)),
            textColor: Colors.green,

            onPressed: moveToLogin,
            
          ),

          
        ];
    }
  }

}