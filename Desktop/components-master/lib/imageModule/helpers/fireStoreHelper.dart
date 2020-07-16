import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  Firestore db = Firestore.instance;

  StreamSubscription<List> subscription;

  Future<String> createTransaction(int listLength) async {
    Map<String, Map<String, String>> emptyImageMap = Map();

    for (int i = 0; i < listLength; i++) {
      emptyImageMap.addAll({
        'key$i': {
          'image': 'empty',
          'thumbnail': 'empty',
        }
      });
    }
    DocumentReference docRef = await db.collection("image-module-test").add({
      'name': "test",
      'images': emptyImageMap,
    });

    return docRef.documentID;
  }

  Future<bool> updateTransactionWithImages(Map<String, Map<String, String>> imageMap, String docId) async {
    var transactionRef = db.collection("image-module-test").document(docId);
    bool result = false;

    await transactionRef.updateData({'images': imageMap}).then((value) {
      result = true;
      return true;
    }).catchError((error) {
      result = false;
      return false;
    });

    return result;
  }

  Future<List> getAllTransactions() async {
    final Map<String, Map<String, Map<String, String>>> result = Map();
    await db
        .collection("image-module-test")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((documnets) {
        Map<String, dynamic> docResult =
            Map<String, dynamic>.from(documnets.data['images']);
        // print(docResult);
        final Map<String, Map<String, String>> map = Map();
        for (var keys in docResult.keys) {
          map[keys.toString()] = {
            'image': docResult[keys]['image'].toString(),
            'thumbnail': docResult[keys]['thumbnail'].toString(),
          };
        }
        result[documnets.documentID] = map;
      });
    });
    var list = result.entries.toList();
    return list;
  }

  StreamController getTransactionStream() {
    final StreamController<List> streamController =
        new StreamController<List>();

    List<String> result = List();
    var x = db.collection("image-module-test").snapshots();
    db.collection("image-module-test").snapshots().listen(
      (documents) {
        List x = List();
        documents.documents.forEach((document) {
          x.add(document.documentID);
        });
        streamController.sink.add(x);
      },
      onDone: () {
        print("asdasd");
      },
    ).onDone(() {
      result.clear();
      streamController.close();
    });
    result.clear();
    return streamController;
  }

  StreamController getStream(String transactionId) {
    final StreamController<List> streamController =
        new StreamController<List>();
    var document = db.collection("image-module-test").document(transactionId);

    document.snapshots().listen((document) {
      final Map<String, Map<String, String>> result = Map();
      if (document != null) {
        if (document.data['images'] != null) {
          Map<String, dynamic> docResult =
              Map<String, dynamic>.from(document.data['images']);
          final Map<String, Map<String, String>> map = Map();
          if (docResult != null) {
            print(docResult.length);
            if (docResult.length > 0) {
              for (var keys in docResult.keys) {
                map[keys.toString()] = {
                  'image': docResult[keys]['image'].toString(),
                  'thumbnail': docResult[keys]['thumbnail'].toString(),
                };
              }
              result.addAll(map);
              var list = result.entries.toList();
              streamController.sink.add(list);
            } else {
              List list = List();
              streamController.sink.add(list);
            }
          } else {
            List list = List();
            streamController.sink.add(list);
          }
        } else {
          List list = List();
          streamController.sink.add(list);
        }
      }
    }).onDone(() {
      streamController.close();
    });

    return streamController;
  }

  Future<bool> removeFromMap(String transactionId, String key) async {
    bool removed = false;
    var document = db.collection("image-module-test").document(transactionId);
    print(key);

    await document
        .updateData({"images.$key": FieldValue.delete()}).then((value) {
      print("updated");
      removed = true;
    }).catchError((error) {
      print(error);
      removed = false;
    });

    return removed;
  }

  Future<bool> addToMap(
    String transactionId,
    Map<String, Map<String, String>> imageMap,
  ) async {
    bool result = false;
    var document = db.collection("image-module-test").document(transactionId);

    for (var image in imageMap.entries.toList()) {
      print("key ${image.key}");
      print("value ${image.value}");
      await document.updateData({
        // "img": FieldValue.arrayRemove(["{x}"])
        "images.${image.key}": image.value
      }).then((value) {
        result = true;
        print("updated");
      }).catchError((error) {
        result = false;
        print(error);
        return false;
      });
    }
    return result;

    // document.updateData({
    //   // "img": FieldValue.arrayRemove(["{x}"])
    //   "imgg.x": {'x11': '4'}
    // }).then((value) {
    //   print("updated");
    // }).catchError((error) {
    //   print(error);
    // });
  }
}
