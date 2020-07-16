import 'dart:io';

import 'package:flutter/material.dart';
import 'package:components/imageModule/widgets/imageSourceSelector.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerHelper {
  Future<String> showImageSourceDialog(BuildContext context) async {
    String source = await showModalBottomSheet<String>(
        context: context,
        isDismissible: false,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 90,
            child: Container(
              child: BottomImageSourceSelector(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });

    return source;
  }

  Future<List<File>> loadImagesFromGallery() async {
    List<Asset> resultList = List<Asset>();
    List<File> resultImageList = List<File>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarTitle: "Select Photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    for (var asset in resultList) {
      print("strrr : ${asset.toString()}");
      File imageFile = await getImageFromAsset(asset);
      if (imageFile != null) resultImageList.add(imageFile);
    }

    return resultImageList;
  }

  Future<File> getImageFromAsset(Asset asset) async {
    ByteData _byteData = await asset.getByteData(quality: 100);

    File imageFile = await writeToFile(_byteData);

    // Image image = Image.memory(_byteData.buffer.asUint8List());

    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  Future<File> loadImageFromCamera() async {
    final picker = ImagePicker();
    File imageFile;
    PickedFile pickedFile;

    print("assdd");
    pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);

      File croppedImage = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          cropStyle: CropStyle.rectangle,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop Selcted Image',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Crop Selcted Image',
          ));
      imageFile = croppedImage ?? imageFile;
      return imageFile;
    } else
      return null;
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath +
        "/pickedImage" +
        DateTime.now().toString(); // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(buffer.asUint8List());
  }
}
