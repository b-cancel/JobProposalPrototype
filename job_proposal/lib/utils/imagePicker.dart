//dart
import 'dart:io';

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_proposal/main.dart';

//functions that make life easier
Future<String> showImagePicker(
  BuildContext context,
) async {
  bool isLeft = true;
  //returns newly selected imageUrl
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ImageSelectButtonUI(
                  isLeft: true,
                ),
                ImageSelectButtonUI(
                  isLeft: false,
                ),
              ],
            ),
            //function is seperate from UX
            //given layout limitation in dialog boxes
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    ImageSelectButton(
                      isLeft: true,
                    ),
                    ImageSelectButton(
                      isLeft: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class ImageSelectButton extends StatelessWidget {
  const ImageSelectButton({
    @required this.isLeft,
    Key key,
  }) : super(key: key);

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => changeImage(
          context,
          isLeft,
        ),
        child: Container(),
      ),
    );
  }
}

class ImageSelectButtonUI extends StatelessWidget {
  ImageSelectButtonUI({
    @required this.isLeft,
  });

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    BorderSide stdBorder = BorderSide(width: 1, color: lbGrey);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: isLeft ? stdBorder : BorderSide.none,
            left: isLeft ? BorderSide.none : stdBorder,
          )
        ),
        padding: EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              child: Text(
                isLeft ? "Gallery" : "Camera",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Icon(
              isLeft ? FontAwesome5.images : Icons.camera,
              size: 56,
            ),
          ],
        ),
      ),
    );
  }
}

//this is called from a dialog box
//so we return by poping the pop up
//with our new location
changeImage(BuildContext context, bool isGallery) async {
  //NOTE: here we KNOW that we have already been given the permissions we need
  //TODO: ask for permissions aren't requested
  File retreivedImage = await ImagePicker.pickImage(
    source: (isGallery) ? ImageSource.gallery : ImageSource.camera,
  );

  //if an image was actually selected
  if (retreivedImage != null) {
    Navigator.of(context).pop(
      retreivedImage.path,
    );
  }
  //ELSE... we back out of selecting it
  //but we assume the user MIGHT just be trying to 
  //take a photo instead of finding it or the inverse
}