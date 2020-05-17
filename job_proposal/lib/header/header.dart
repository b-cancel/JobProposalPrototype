//flutter
import 'package:flutter/material.dart';

//internal
import 'package:job_proposal/data/structs.dart';
import 'package:job_proposal/header/helper.dart';
import 'package:job_proposal/main.dart';
import 'package:job_proposal/map.dart';

//widget
class HeaderSliver extends StatelessWidget {
  const HeaderSliver({
    Key key,
    @required this.statusBarHeight,
    @required this.topAppBarHeight,
    @required this.accentHeight,
    @required this.bottomAppBarHeight,
    //data
    @required this.clientData,
    @required this.addingLineItem,
  }) : super(key: key);

  final double statusBarHeight;
  final double topAppBarHeight;
  final double accentHeight;
  final double bottomAppBarHeight;
  //data
  final ClientData clientData;
  final ValueNotifier<bool> addingLineItem;

  @override
  Widget build(BuildContext context) {
    //the bottom bar is included here
    double flexibleHeight = accentHeight;
    //add extra space for visual elements that wont be the accent color
    //flexibleHeight += widget.statusBarHeight; //equivalent to bottom buttons not factored into ratio
    flexibleHeight += topAppBarHeight;

    //build
    return SliverAppBar(
      backgroundColor: lbGreen,
      //the top title (is basically the bottom AppBar)
      //NOTE: leading to left of title
      //NOTE: title in middle
      //NOTE: action to right of title
      //show extra top padding
      primary: true,
      //only show shadow if content below
      forceElevated: false,
      //snapping is annoying and disorienting
      //but the opposite is ugly
      snap: false,
      //on se we can always add a dose and change the medication settings
      pinned: true,
      //might make it open in annoying times (so we turn it off)
      floating: true,
      //bottom app bar (always visible)
      bottom: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          bottomAppBarHeight,
        ),
        child: SliverBottomAppBar(
          bottomAppBarHeight: bottomAppBarHeight,
          addingLineItem: addingLineItem,
        ),
      ),
      //most of the screen
      expandedHeight: flexibleHeight,
      //the graph
      stretch: false,
      flexibleSpace: FlexibleSpaceBar(
        //pin, pins on bottom
        //parallax keeps the background centered within flexible space
        collapseMode: CollapseMode.parallax,
        //TODO: check if this is working at all
        stretchModes: [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        //the background with the graph and active dose
        background: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: ThemeData.dark().primaryColorDark,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: statusBarHeight,
                bottom: bottomAppBarHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: topAppBarHeight,
                    child: PreferredSize(
                      preferredSize: Size(
                        MediaQuery.of(context).size.width,
                        topAppBarHeight,
                      ),
                      child: SliverTopAppBar(
                        clientName: clientData.name,
                      ),
                    ),
                  ),
                  Expanded(
                    child: MapOfAddress(
                      clientData: clientData,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}