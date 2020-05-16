//flutter
import 'package:flutter/material.dart';

//internal
import 'package:job_proposal/utils/goldenRatio.dart';
import 'package:job_proposal/data/structs.dart';
import 'package:job_proposal/header/header.dart';

//widget
class FormBody extends StatelessWidget {
  FormBody({
    this.appBarHeight: 56, //set by flutter as default
    @required this.statusBarHeight,
    @required this.entireScreenHeight,
    @required this.toggleButtonHeight,
    //data
    @required this.clientData,
  });

  //values used to get nice looking ratio for header sliver
  final double appBarHeight;
  final double statusBarHeight;
  final double toggleButtonHeight;
  final double entireScreenHeight;
  //data
  final ClientData clientData;

  @override
  Widget build(BuildContext context) {    
    //create app bar
    Widget sliverAppBar = HeaderSliver(
      statusBarHeight: statusBarHeight,
      topAppBarHeight: appBarHeight,
      //includes the bottom app bar
      //it doesn't feel like the statusBarHeight is part of the app in terms of visual ratio
      //so I don't count it when doing the ratio math
      //the top app bar KINDA doesn't feel like a part of it since it blends with the status bar
      //so I don't count it either
      accentHeight: toGoldenRatioBig(
        entireScreenHeight - statusBarHeight - appBarHeight,
      ),
      bottomAppBarHeight: appBarHeight,
      //data
      clientData: clientData,
    );

    //create filler for when there are no items
    Widget fillRemainingSliver = SliverFillRemaining(
      hasScrollBody: false, //it should be as small as possible
      fillOverscroll: true, //only if above is false
      child: Center(
        child: Text(
          "Add a Task\nyour tasks will show up here",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeData.dark().cardColor,
          ),
        ),
      ),
    );

    //combine slivers
    List<Widget> slivers = new List<Widget>();
    slivers.add(sliverAppBar);
    /*
    slivers.add(
      SliverToBoxAdapter(
        child: Container(
          height: entireScreenHeight * 2,
        ),
      ),
    );
    */
    slivers.add(fillRemainingSliver);

    //return
    //build
    return Container(
      child: CustomScrollView(
        slivers: slivers,
      ),
    );
  }
}

/*
    //generate group widgets
    List<Widget> groups = new List<Widget>();
    for (int i = 0; i < doseGroups.length; i++) {
      groups.add(
        DoseGroup(
          group: doseGroups[i],
          doseIDtoActiveDoseVN: doseIDtoActiveDoseVN,
          lastGroup: i == (doseGroups.length - 1),
          theSelectedDateTime: theSelectedDateTime,
          lastDateTime: lastDateTime,
          otherCloseOnToggle: othersCloseOnToggle,
          autoScrollController: widget.autoScrollController,
        ),
      );
    }

    
    slivers.add(addDoseBox);
    slivers.addAll(groups);
    */