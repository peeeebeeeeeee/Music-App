import 'package:flutter/material.dart';

class BottomImageSourceSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                      Text(
                        "   Camera",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    "camera",
                  ),
                ),
                FlatButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo,
                        size: 30,
                      ),
                      Text(
                        "   Gallery",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    "gallery",
                  ),
                ),
              ],
            )));
  }
}
