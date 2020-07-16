import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:intl/intl.dart';

class FirebaseStorageHelper {
  Function(int) imagesUploaded;

  FirebaseStorageHelper({this.imagesUploaded});

  Future<CloudStorageResult> uploadImage(
      {@required File imageToUpload,
      @required String title,
      @required String directory}) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/$directory/$title');

    StorageUploadTask uploadImage = storageReference.putFile(imageToUpload);

    // var downloadUrl;
    StorageTaskSnapshot storageSnapshot = await uploadImage.onComplete;

    var url = await storageSnapshot.ref.getDownloadURL();

    print("uploaded $url");

    return CloudStorageResult(
      imageUrl: url.toString(),
      imageFileName: title,
    );
  }

  Future<Map<String, Map<String, String>>> batchImageUpload(
      List<File> imageList, String directory) async {
    print("leee : $imageList");
    Map<String, Map<String, String>> resultMap = Map();
    int count = 0;

    for (var image in imageList) {
      var now = new DateTime.now();
      var miliSecondsRemoved = now.toString().split('.')[0];
      String imagetitle = "image-" + miliSecondsRemoved;
      String thumbnailTitle = "thumb-" + miliSecondsRemoved;

      var thumbnail =
          Img.copyResize(Img.decodeImage(image.readAsBytesSync()), width: 120);
      var thumbData = Img.encodePng(thumbnail);
      File thumbFile = await writeThumbToFile(thumbData);

      print(thumbFile.path);

      CloudStorageResult imageStorageResult = await uploadImage(
          imageToUpload: image, title: imagetitle, directory: directory);
      CloudStorageResult thumbStorageResult = await uploadImage(
          imageToUpload: thumbFile,
          title: thumbnailTitle,
          directory: directory);

      Map<String, Map<String, String>> imagesMap = {
        imagetitle: {
          'image': imageStorageResult.imageUrl,
          'thumbnail': thumbStorageResult.imageUrl
        }
      };

      resultMap.addAll(imagesMap);
      // imagesUploaded(++count);
    }

    print(resultMap);
    return resultMap;
  }

  Future<File> writeThumbToFile(List<int> data) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath +
        "/pickedImage" +
        DateTime.now().toString(); // file_01.tmp is dump file, can be anything
    return new File(filePath)..writeAsBytes(data);
  }

  Future<bool> deletImageFromStorage(String url) async {
    bool result = false;

    StorageReference photoref =
        await FirebaseStorage().getReferenceFromUrl(url);

    await photoref.delete().then((value) {
      result = true;
    }).catchError((e) {
      print(e);
      result = false;
    });

    return result;
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
