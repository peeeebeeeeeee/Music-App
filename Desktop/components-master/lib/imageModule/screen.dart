import 'dart:io';

import 'package:components/imageModule/mainModule.dart';
import 'package:components/imageModule/viewTransactions.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  static const String id="Image Screen";
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  List<Object> images = List<Object>();
  ImageModule module;

  @override
  void initState() {
    module = ImageModule(
      onUpload: () {
        print("uploaded");
        List<File> empty = [];
        updateView(empty);
      },
      onError: (String error) {
        print(error);
      },
    );
    images.add("add image");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image module")),
      body: Builder(builder: (context) {
        return Column(
          children: [
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              childAspectRatio: 1,
              children: List.generate(images.length, (index) {
                if (index == 0) {
                  return Card(
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        List<File> updatedList =
                            await module.pickImageForNewTransaction(context);
                        if (updatedList != null) updateView(updatedList);
                      },
                    ),
                  );
                } else {
                  File image = images[index];
                  return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Image(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                          left: 5,
                          top: 5,
                          child: InkWell(
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                            onTap: () {
                              List<File> updatedList =
                                  module.removeImage(index - 1);
                              updateView(updatedList);
                            },
                          ),
                        ),
                      ]));
                }
              }),
            ),
            Padding(padding: EdgeInsets.all(20)),
            RaisedButton(
                child: Text("upload"),
                onPressed: () async {
                  module.createAndUpload(context);
                }),
            Padding(padding: EdgeInsets.all(20)),
            RaisedButton(
                child: Text("view"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewTransactions()));
                })
          ],
        );
      }),
    );
  }

  void updateView(List<File> updatedList) {
    setState(() {
      images = ["add image"];
      images.insertAll(1, updatedList);
    });
  }
}
