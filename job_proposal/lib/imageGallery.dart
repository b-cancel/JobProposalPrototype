import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_proposal/data/structs.dart';
import 'package:job_proposal/main.dart';
import 'package:job_proposal/utils/goldenRatio.dart';

class ImageGallery extends StatefulWidget {
  ImageGallery({
    @required this.imageGalleryHeight,
    @required this.imageLocations,
  });

  final double imageGalleryHeight;
  final ValueNotifier<List<ImageLocation>> imageLocations;

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.imageLocations.addListener(updateState);
  }

  @override
  void dispose() {
    widget.imageLocations.removeListener(updateState);
    super.dispose();
  }

  removeImage(int index) {
    //TODO: optmize this

    //make of copy of the list
    List<ImageLocation> imageLocationsCopy = List<ImageLocation>.from(
      widget.imageLocations.value,
    );

    //edit the copy of the list
    imageLocationsCopy.removeAt(index);

    //have the notifier update, which then updates state
    widget.imageLocations.value = imageLocationsCopy;
  }

  @override
  Widget build(BuildContext context) {
    int imageLocationsCount = widget.imageLocations.value.length;
    int lastIndex = imageLocationsCount - 1;
    return Visibility(
      visible: imageLocationsCount > 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 24,
        ),
        //as tall as our sliver header
        height: toGoldenRatioBig(
          widget.imageGalleryHeight,
        ),
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageLocationsCount,
          itemBuilder: (context, indexInVisualList) {
            //same as our regular list
            //new images on the left
            //since otherwise the user wont get the confirmation that the image was added
            int indexInActualList = lastIndex - indexInVisualList;
            ImageLocation aImageLocation =
                widget.imageLocations.value[indexInActualList];

            File file = File(aImageLocation.location);
            if (file.existsSync() == false) {
              //NOTE: here we delete if not found
              //they deleted it manually
              //or they moved it manually
              //so you should delete it too

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  removeImage(indexInActualList);
                }
              });

              return Container();
            } else {
              return Padding(
                key: ValueKey(
                  //NOTE: using i to distinguish line items
                  "i" + aImageLocation.id.toString(),
                ),
                padding: EdgeInsets.only(
                  right: indexInActualList == 0 ? 24 : 16,
                ),
                child: Stack(
                  children: <Widget>[
                    Image.file(
                      file,
                      fit: BoxFit.fitHeight,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            toFullScreen(
                              file,
                              () => removeImage(indexInActualList),
                            );
                          },
                          child: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  toFullScreen(File file, Function onDelete) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        double maxWidth = MediaQuery.of(context).size.width - (24 * 2);
        double maxHeight = MediaQuery.of(context).size.height - (36 * 2);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Container(
            height: maxHeight,
            width: maxWidth,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: maxHeight,
                  width: maxWidth,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Image.file(
                          file,
                          fit: BoxFit.contain,
                        ),
                      ),
                      //blocked by the button below
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ClipOval(
                            child: Material(
                              color: lbGreen,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onDelete();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
