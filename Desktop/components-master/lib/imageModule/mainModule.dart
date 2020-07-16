import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'helpers/fireStoreHelper.dart';
import 'helpers/firebaseStorageHelper.dart';
import 'helpers/imagePicker.dart';

class ImageModule {
  List<File> _imageList = List<File>();
  List existingImageList = List();
  VoidCallback onUpload;
  Function(int listLength) onImagePicked;
  Function(String) onError;

  static final ImageModule _instance = ImageModule._internal();

  factory ImageModule(
      {VoidCallback onUpload,
      Function(String) onError,
      Function(int listLength) onImagePicked}) {
    _instance.onUpload = onUpload;
    _instance.onError = onError;
    _instance.onImagePicked = onImagePicked;
    return _instance;
  }

  ImageModule._internal();

  Future<List<File>> pickImage(BuildContext context) async {
    String source = await ImagePickerHelper().showImageSourceDialog(context);
    List<File> imageList = List();
    if (source != null) {
      if (source == "gallery") {
        List<File> imageListFromGallery =
            await ImagePickerHelper().loadImagesFromGallery();
        if (imageListFromGallery.length > 0) {
          imageList.addAll(imageListFromGallery);
          // _instance._imageList.addAll(imageList);
          return imageList;
        }
      } else if (source == "camera") {
        File image = await ImagePickerHelper().loadImageFromCamera();
        print(_instance._imageList.length);
        if (image != null) {
          imageList.add(image);
          // _instance._imageList.add(image);
          return imageList;
        }
      }
    } else {
      return null;
    }
  }

  Future<List<File>> pickImageForNewTransaction(BuildContext context) async {
    List<File> images = await pickImage(context);

    _instance._imageList.addAll(images);
    return _instance._imageList;
  }

  Future<void> pickImageForExistingTransaction(
      BuildContext context, String transactionId) async {
    await pickImage(context).then((imageList) => {
          if (imageList != null)
            {
              print(imageList.length),
              _instance.onImagePicked(imageList.length),
              addToTransaction(transactionId, context, imageList)
                  .then((uploaded) {
                if (uploaded) {
                  _instance.onUpload();
                } else {
                  _instance.onError("unable to upload");
                }
              })
            }
        });
  }

  List<File> removeImage(int index) {
    _instance._imageList.removeAt(index);
    return _instance._imageList;
  }

  Future<bool> createAndUpload(BuildContext context) async {
    bool result = false;
    var snackBar = SnackBar(content: Text("Uploading"));
    Scaffold.of(context).showSnackBar(snackBar);
    FireStoreHelper()
        .createTransaction(_instance._imageList.length)
        .then((docId) => {
              FirebaseStorageHelper()
                  .batchImageUpload(_instance._imageList, docId)
                  .then((imagesMap) async {
                FireStoreHelper()
                    .updateTransactionWithImages(imagesMap, docId)
                    .then((result) {
                  if (result) {
                    snackBar = SnackBar(content: Text("Uploaded Successfully"));
                    _instance._imageList.clear();
                    Scaffold.of(context).showSnackBar(snackBar);
                    _instance.onUpload();
                    result = true;
                  } else {
                    snackBar = SnackBar(content: Text("Uploading Failed"));
                    Scaffold.of(context).showSnackBar(snackBar);
                    _instance.onError("failed");
                    result = false;
                  }
                });
              }),
            });
  }

  Future<List> getAllTransactions() async {
    return await FireStoreHelper().getAllTransactions();
  }

  StreamController getTransactionStream() {
    try {
      return FireStoreHelper().getTransactionStream();
    } catch (e) {
      print(e);
    }
  }

  StreamController getStream(String transactionId) {
    var controller = FireStoreHelper().getStream(transactionId);
    StreamSubscription<List> streamSubscription =
        controller.stream.listen((event) {
      _instance.existingImageList = event;
    }, onError: (error) {
      print(error);
    });
    try {
      return FireStoreHelper().getStream(transactionId);
    } catch (e) {
      print("error $e");
    }
  }

  Future<bool> removeFromExistingTransaction(
      String transactionId, int index, BuildContext context) async {
    Map<String, Map<String, String>> updatedMap = Map();
    bool result = false;

    String confirmation = await showConfirmDialog(context);
    if (confirmation != null && confirmation == "yes") {
      SnackBar snackBar;

      snackBar = SnackBar(
        content: Text("Removing"),
        duration: Duration(milliseconds: 500),
      );
      Scaffold.of(context).showSnackBar(snackBar);

      bool removed = await FirebaseStorageHelper().deletImageFromStorage(
          _instance.existingImageList[index].value["image"]);

      if (removed != null && removed) {
        bool thumbNailRemoved = await FirebaseStorageHelper()
            .deletImageFromStorage(
                _instance.existingImageList[index].value["thumbnail"]);

        if (thumbNailRemoved != null && removed) {}

        _instance.existingImageList.removeAt(index);

        _instance.existingImageList.forEach((element) {
          updatedMap[element.key] = element.value;
        });

        print("updated \n");

        print(updatedMap.length);

        result = await FireStoreHelper()
            .updateTransactionWithImages(updatedMap, transactionId);

        if (result) {
          snackBar = SnackBar(content: Text("Removed Successfully"));
          Scaffold.of(context).showSnackBar(snackBar);
          _instance._imageList.clear();
        } else {
          snackBar = SnackBar(content: Text("Removing Failed"));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    }

    return result;
  }

  Future<bool> addToTransaction(
      String transactionId, BuildContext context, List imageMap) async {
    Map<String, Map<String, String>> imagesMap =
        await FirebaseStorageHelper().batchImageUpload(imageMap, transactionId);

    bool result = await FireStoreHelper().addToMap(transactionId, imagesMap);

    print("result $result");

    SnackBar snackBar;
    if (result) {
      _instance._imageList.clear();
      snackBar = SnackBar(content: Text("Uploaded Successfully"));
      Scaffold.of(context).showSnackBar(snackBar);
      return true;
    } else {
      snackBar = SnackBar(content: Text("Uploading Failed"));
      Scaffold.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  Future<bool> removeImageFromTransaction(
      String transactionId, int index, BuildContext context) async {
    bool result = false;

    String confirmation = await showConfirmDialog(context);
    if (confirmation != null && confirmation == "yes") {
      SnackBar snackBar;

      snackBar = SnackBar(
        content: Text("Removing"),
        duration: Duration(milliseconds: 500),
      );
      Scaffold.of(context).showSnackBar(snackBar);

      bool removed = await FirebaseStorageHelper().deletImageFromStorage(
          _instance.existingImageList[index].value["image"]);

      if (removed != null && removed) {
        bool thumbNailRemoved = await FirebaseStorageHelper()
            .deletImageFromStorage(
                _instance.existingImageList[index].value["thumbnail"]);

        if (thumbNailRemoved != null && removed) {
          result = await FireStoreHelper().removeFromMap(
              transactionId, _instance.existingImageList[index].key);
          if (result) {
            snackBar = SnackBar(content: Text("Removed Successfully"));
            Scaffold.of(context).showSnackBar(snackBar);
            _instance._imageList.clear();
            return result;
          } else {
            snackBar = SnackBar(content: Text("Removing Failed"));
            Scaffold.of(context).showSnackBar(snackBar);
            return result;
          }
        }
      }
    }

    print(result);

    return result;
  }

  Future<String> showConfirmDialog(BuildContext context) async {
    String selection = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Confirm Remove !"),
            content: Text(
                "Do you really want to remove the seelcted image?\nThis change can't be reverted back"),
            actions: [
              CupertinoDialogAction(
                child: Text("NO"),
                onPressed: () {
                  Navigator.pop(context, "no");
                },
              ),
              CupertinoDialogAction(
                child: Text("YES"),
                onPressed: () {
                  Navigator.pop(context, "yes");
                },
              )
            ],
          );
        });
    if (selection != null) return selection;
  }
}
