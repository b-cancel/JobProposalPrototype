//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:job_proposal/header/helper.dart';
import 'package:job_proposal/main.dart';
import 'package:job_proposal/utils/dateTimePicker/field.dart';

//internal
import 'package:job_proposal/utils/goldenRatio.dart';
import 'package:job_proposal/data/structs.dart';
import 'package:job_proposal/header/header.dart';

//NOTE: must be stateful so the valuenotifiers work as desried
class FormBody extends StatefulWidget {
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

  //due date required before
  static DateTime nullDateTime = DateTime(1900);

  @override
  _FormBodyState createState() => _FormBodyState();
}

class _FormBodyState extends State<FormBody> {
  final ScrollController scrollController = ScrollController();

  final ValueNotifier<DateTime> dueDateSelected = ValueNotifier<DateTime>(
    FormBody.nullDateTime,
  );

  final ValueNotifier<bool> showError = ValueNotifier<bool>(
    false,
  );

  @override
  Widget build(BuildContext context) {
    //create app bar
    Widget sliverAppBar = HeaderSliver(
      statusBarHeight: widget.statusBarHeight,
      topAppBarHeight: widget.appBarHeight,
      //includes the bottom app bar
      //it doesn't feel like the statusBarHeight is part of the app in terms of visual ratio
      //so I don't count it when doing the ratio math
      //the top app bar KINDA doesn't feel like a part of it since it blends with the status bar
      //so I don't count it either
      accentHeight: toGoldenRatioBig(
        widget.entireScreenHeight -
            widget.statusBarHeight -
            widget.appBarHeight,
      ),
      bottomAppBarHeight: widget.appBarHeight,
      //data
      clientData: widget.clientData,
    );

    //generate group widgets
    List<Widget> tasks = new List<Widget>();
    /*
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
    }*/

    Widget dueDateSelector = SliverToBoxAdapter(
      child: CustomDateTimePicker(
        dueDateSelected: dueDateSelected,
        showError: showError,
      ),
    );

    Widget submitButton = SliverToBoxAdapter(
      child: SubmitButton(
        hasTasks: tasks.length > 0,
        scrollController: scrollController,
        dueDateSelected: dueDateSelected,
        showError: showError,
      ),
    );

    //create filler for when there are no items
    Widget fillRemainingSliver = SliverFillRemaining(
      hasScrollBody: false, //it should be as small as possible
      fillOverscroll: true, //only if above is false
      //if they try to send without adding a task
      //the snackbar will tell them they need to add one
      child: Container(),
    );

    //combine slivers
    List<Widget> slivers = new List<Widget>();
    slivers.add(sliverAppBar);
    slivers.addAll(tasks);
    slivers.add(dueDateSelector);
    slivers.add(submitButton);
    slivers.add(fillRemainingSliver);

    //return
    //build
    return Container(
      child: CustomScrollView(
        controller: scrollController,
        slivers: slivers,
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    Key key,
    @required this.hasTasks,
    @required this.scrollController,
    @required this.dueDateSelected,
    @required this.showError,
  }) : super(key: key);

  final bool hasTasks;
  final ScrollController scrollController;
  final ValueNotifier<DateTime> dueDateSelected;
  final ValueNotifier<bool> showError;

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  scrollToTopIfTrue() {
    if (widget.showError.value) {
      widget.scrollController.animateTo(
        0,
        //match default behavior
        duration: kTabScrollDuration,
        //specifically chosen to make it clear scroll is happening
        //and slow down so the user understand what item we were scroll to
        curve: Curves.easeOut,
      );
    }
  }

  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    //switch out button text
    JobForm.isOrder.addListener(updateState);
    //scroll to top if the user tries to submit with a due date
    widget.showError.addListener(scrollToTopIfTrue);
  }

  @override
  void dispose() {
    JobForm.isOrder.removeListener(updateState);
    widget.showError.removeListener(scrollToTopIfTrue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String basicAction = "Sending The Job ";
    String formAction = JobForm.isOrder.value ? "Order" : "Proposal";
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: RaisedButton(
          color: Theme.of(context).accentColor,
          child: Text(
            "Send Job " + formAction,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            //if no date has been selected let it show as an error in the text field
            if (isDateNull(widget.dueDateSelected.value)) {
              widget.showError.value = true;
            } else {
              //date was selected, now just worry about tasks
              if (widget.hasTasks) {
                visualPrint(
                  context,
                  basicAction + formAction + "...",
                );
              } else {
                visualPrint(
                  context,
                  "Must Add Atleast 1 Task\nBefore " + basicAction + formAction,
                );
              }
            }
          },
        ),
      ),
    );
  }
}

//date == date isn't implemented or fails
//so I just compare against their working to strings
bool areDatesEqual(DateTime left, DateTime right) {
  return (left.toString() == right.toString());
}

bool isDateNull(DateTime date) {
  return areDatesEqual(date, FormBody.nullDateTime);
}
