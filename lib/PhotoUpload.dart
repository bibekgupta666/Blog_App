import 'dart:io';

import 'package:blog_app/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPhotoPage extends StatefulWidget
{
  State<StatefulWidget> createState()
  {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage>
{
  File sampleImage; //this will be the image file which user will select from galary
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>(); //this key is used to distinguish forms

  Future getImage(bool isCamera) async 
  {
    File tempImage;
    if(isCamera)
    {
       tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    }else
    {
       tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() 
    {
      sampleImage = tempImage;
    });
  }

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

  void uploadStatusImage() async
  {
    if(validateAndSave())
    {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      goToHomePage();
      
            saveToDatabase(url);
            
          }
        }
      
        void saveToDatabase(String url) 
        {
          var dbTimeKey = new DateTime.now();
          var formatDate = new DateFormat('MMM d, yyyy');
           var formatTime = new DateFormat('EEEE, hh:mm aaa');
      
           String date = formatDate .format(dbTimeKey);
           String time = formatTime .format(dbTimeKey);
      
           DatabaseReference ref = FirebaseDatabase.instance.reference();
      
           var data = 
           {
             "image": url,
             "description": _myValue,
             "date": date,
             "time": time,
           };
      
          ref.child("Posts").push().set(data);
        }

        void goToHomePage() 
        {
          Navigator.push
                (
                  context, 
                  MaterialPageRoute(builder: (context)
                  {
                    return new HomePage();
                  })
                );
        }
            
              @override
              Widget build(BuildContext context) 
              {
                // TODO: implement build
                return new Scaffold
                (
                  resizeToAvoidBottomPadding: false,
                  appBar: new AppBar
                  (
                    title: new Text("Image Upload"),
                    centerTitle: true,
                  ),
            
                  body: new Center
                  (
                    child: sampleImage == null? Text("Select an Image"): enableUpload(),
                  ),
  
                  bottomNavigationBar: new BottomAppBar
                  (
                    color: Colors.green,
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
                            icon: new Icon(Icons.camera_alt),
                            iconSize: 50,
                            color: Colors.white,
                            onPressed: ()
                            {
                              getImage(true);
                            }
                          ),

                          new IconButton
                          (
                            icon: new Icon(Icons.insert_drive_file),
                            iconSize: 50,
                            color: Colors.white,
                            onPressed: ()
                            {
                              getImage(false);
                            }
                          )
                        ],
                      ),
                    ),
                  ),
            
            
                );
              }
            
              Widget enableUpload()
              {
                return Container
                (
                  child: new Form
                  (
                      key: formKey,
            
                    child: Column
                    (
                      children: <Widget>
                      [
                        Image.file(sampleImage, height: 330.0, width: 660.0,), //user selected image will be displayed
                        SizedBox(height: 15.0,), //this will add space
            
                        TextFormField
                        (
                          decoration: new InputDecoration(labelText: 'Description'),
            
                          validator: (value)
                          {
                            return value.isEmpty? 'Please describe a bit about Picture' : null;
                          },
                          onSaved: (value)
                          {
                          return _myValue = value;
                          },
                        ),
                        SizedBox(height: 15.0,),
            
                        RaisedButton
                        (
                          elevation: 10.0,
                          child: Text("Create Post"),
                          textColor: Colors.white,
                          color: Colors.green,
                          onPressed: uploadStatusImage,
                        )
                      ],
                    ),
                  ),
                );
              }
}