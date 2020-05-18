//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:job_proposal/header/helper.dart';
import 'package:job_proposal/list.dart';
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
  //detects when we tap the add button so that we can add the item
  final ValueNotifier<bool> addingLineItem = new ValueNotifier<bool>(
    false,
  );

  //the values that would be used to generate our Job and save it on the server
  final ValueNotifier<List<LineItem>> lineItems = ValueNotifier<List<LineItem>>(
    new List<LineItem>(),
  ); 
  final ValueNotifier<DateTime> dueDateSelected = ValueNotifier<DateTime>(
    FormBody.nullDateTime,
  );

  //if we try to submit the proposal or order without first
  //adding a due date -> showError & scrollToTheTop
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> showError = ValueNotifier<bool>(
    false,
  );

  //build
  @override
  Widget build(BuildContext context) {
    double accentHeight = toGoldenRatioSmall( 
      widget.entireScreenHeight -
          widget.statusBarHeight -
          widget.appBarHeight,
    );

    //create app bar
    Widget sliverAppBar = HeaderSliver(
      statusBarHeight: widget.statusBarHeight,
      topAppBarHeight: widget.appBarHeight,

      //includes the bottom app bar
      //it doesn't feel like the statusBarHeight is part of the app in terms of visual ratio
      //so I don't count it when doing the ratio math
      //the top app bar KINDA doesn't feel like a part of it since it blends with the status bar
      //so I don't count it either

      //NOTE: we are using the smaller option so the keyboard doesn't cover on field focus
      accentHeight: accentHeight,
      bottomAppBarHeight: widget.appBarHeight,
      //data
      clientData: widget.clientData,
      //data that we add to
      addingLineItem: addingLineItem,
    );

    Widget dueDateSelector = SliverToBoxAdapter(
      child: CustomDateTimePicker(
        dueDateSelected: dueDateSelected,
        showError: showError,
      ),
    );

    Widget submitButton = SliverToBoxAdapter(
      child: SubmitButton(
        lineItems: lineItems,
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
    slivers.add(dueDateSelector);
    slivers.add( //the beef of the project
      LineItemList(
        imageGalleryHeight: accentHeight,
        addingLineItem: addingLineItem,
        lineItems: lineItems,
      ),
    );
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
    @required this.lineItems,
    @required this.scrollController,
    @required this.dueDateSelected,
    @required this.showError,
  }) : super(key: key);

  final ValueNotifier<List<LineItem>> lineItems;
  final ScrollController scrollController;
  final ValueNotifier<DateTime> dueDateSelected;
  final ValueNotifier<bool> showError;

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  //scroll to top should occur always
  //and not just on the first time
  scrollToTop() {
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
  }

  @override
  void dispose() {
    JobForm.isOrder.removeListener(updateState);
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
              print("should be showing error");
              widget.showError.value = true;
              scrollToTop();
            } else {
              //date was selected, now just worry about tasks
              if (widget.lineItems.value.length > 0) {
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
