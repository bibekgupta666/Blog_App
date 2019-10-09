import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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
  final formKey = new GlobalKey<FormState>(); //this key is used to distinguish forms

  Future getImage() async 
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery); 

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

  @override
  Widget build(BuildContext context) 
  {
    // TODO: implement build
    return new Scaffold
    (
      appBar: new AppBar
      (
        title: new Text("Image Upload"),
        centerTitle: true,
      ),

      body: new Center
      (
        child: sampleImage == null? Text("Select an Image"): enableUpload(),
      ),

      floatingActionButton: new FloatingActionButton
      (
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
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
              onPressed: validateAndSave,
            )
          ],
        ),
      ),
    );
  }

}