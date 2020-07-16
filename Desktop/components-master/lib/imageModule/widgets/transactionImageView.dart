import 'dart:io';

import 'package:components/imageModule/helpers/fireStoreHelper.dart';
import 'package:components/imageModule/mainModule.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class TransactionImageView extends StatefulWidget {
  final String transactionId;

  TransactionImageView({this.transactionId});
  @override
  _TransactionImageViewState createState() => _TransactionImageViewState();
}

class _TransactionImageViewState extends State<TransactionImageView> {
  ImageModule module;
  List<dynamic> viewList = List();
  List addingList = List();

  @override
  void initState() {
    module = ImageModule(
      onImagePicked: (int pickedListLength) {
        print("aaaaaaya");
        if (pickedListLength != null) {
          List _addingList = List();
          for (int i = 0; i < pickedListLength; i++) {
            _addingList.add("adding");
          }
          setState(() {
            addingList = _addingList;
          });
        }
      },
      onUpload: () {
        print("updated");
        setState(() {
          addingList.clear();
        });
      },
      onError: (String error) {
        print("not updated $error");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Transaction")),
      body: Builder(builder: (context) {
        return Column(
          children: [
            StreamBuilder(
                stream: module.getStream(this.widget.transactionId).stream,
                builder: (context, snapshot) {
                  viewList = ["add"];
                  if (snapshot.data != null) {
                    print("length " + snapshot.data.length.toString());
                    viewList.insertAll(1, snapshot.data);
                  }
                  if (addingList.length > 0) {
                    viewList.addAll(addingList);
                  } else {
                    viewList.remove("adding");
                  }
                  return GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    children: List.generate(viewList.length, (index) {
                      if (index == 0) {
                        return Card(
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              module.pickImageForExistingTransaction(
                                  context, this.widget.transactionId);
                              // if (updatedList != null) {
                              //   module
                              //       .addToTransaction(
                              //           this.widget.transactionId, context)
                              //       .then((value) {});
                              // }
                            },
                          ),
                        );
                      } else {
                        if (viewList[index] == "adding") {
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator()),
                          );
                        } else {
                          return Card(
                              clipBehavior: Clip.antiAlias,
                              child: Stack(children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child:
                                        (viewList[index].value['thumbnail'] !=
                                                'empty')
                                            ? FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image: viewList[index]
                                                    .value['thumbnail'])
                                            : CircularProgressIndicator()),
                                Positioned(
                                  left: 5,
                                  top: 5,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.remove_circle,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onTap: () async {
                                      bool removed = await module
                                          .removeImageFromTransaction(
                                              this.widget.transactionId,
                                              index - 1,
                                              context);
                                      if (removed) {
                                        print("removed");
                                      }
                                    },
                                  ),
                                ),
                              ]));
                        }
                      }
                    }),
                  );
                }),
          ],
        );
      }),
    );
  }
}
