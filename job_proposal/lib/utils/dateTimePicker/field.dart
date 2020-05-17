//dart
import 'dart:io' show Platform;

//flutter
import 'package:flutter/material.dart';

//internal
import 'package:job_proposal/main.dart';
import 'package:job_proposal/utils/dateTimePicker/androidPicker.dart';
import 'package:job_proposal/utils/dateTimePicker/iosPicker.dart';

//widget
class CustomDateTimePicker extends StatefulWidget {
  CustomDateTimePicker({
    @required this.dueDateSelected,
    @required this.showError,
  });

  final ValueNotifier<DateTime> dueDateSelected;
  final ValueNotifier<bool> showError;

  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  static Duration oneDay = const Duration(days: 1);
  static Duration oneYear = oneDay * 365;
  static Duration humanLifeTime = oneYear * 100;
  static String tab = ""; //"\t\t\t\t\t\t"; //equivalent to about 16 px
  static String helperText = ""; //"A Due Date Is Required*";
  static String errorText =
      ""; //"Atleast an Approximate Due Date is Required*";
  InputBorder standardBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: lbGreen,
      //match default size
      width: 1,
    ),
  );

  //changed throughout
  TextEditingController textEditingController;

  //update the UI upon error detection
  updateState() {
    print("Error is now: " + widget.showError.value.toString());
    if (mounted) {
      setState(() {});
    }
  }

  //update the text when the date changes
  updateText() {
    //update text (we assume its valid)
    textEditingController.text = ourDateTimeFormat(
      widget.dueDateSelected.value,
    );

    //remove error
    widget.showError.value = false;
  }

  //init
  @override
  void initState() {
    super.initState();
    textEditingController = new TextEditingController(
      //this field is required
      //a default is not beneficial
      //and might enforce bad habbits
      //of just not caring about the due date
      text: "",
    );
    widget.dueDateSelected.addListener(updateText);
    widget.showError.addListener(updateState);
  }

  //dispose
  @override
  void dispose() {
    textEditingController.dispose();
    widget.dueDateSelected.removeListener(updateText);
    widget.showError.removeListener(updateState);
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    print("in build error is: " + widget.showError.value.toString());
    return TextField(
      controller: textEditingController,
      //on tap open up the selector
      onTap: () {
        //NOTE: this may or may not update the value notifier
        //that then updates everything else
        if (Platform.isIOS) {
          //TODO: remove the weird military time part of the picker
          selectDateTimeIOS(
            context,
            //give the user some time
            //maybe they forgot to send the job
            //and they want to add it in for their records
            firstDate: DateTime.now().subtract(
              oneYear,
            ),
            //anything else is clearly unrealistic
            lastDate: DateTime.now().add(
              humanLifeTime,
            ),
            //if null will default to DateTime.now()
            selectedDate: widget.dueDateSelected,
          );
        } else {
          selectDateTimeAndroid(
            context,
            //give the user some time
            //maybe they forgot to send the job
            //and they want to add it in for their records
            firstDate: DateTime.now().subtract(
              oneYear,
            ),
            //anything else is clearly unrealistic
            lastDate: DateTime.now().add(
              humanLifeTime,
            ),
            //if null will default to DateTime.now()
            selectedDate: widget.dueDateSelected,
          );
        }
      },
      //we are updating it with the controller
      readOnly: true,
      //still needs to show up as enabled
      //so that on tap works and styling works
      enabled: true,
      //use all the lines you need to show all the details
      minLines: null,
      maxLines: null,
      expands: false,
      /*
      //convience
      toolbarOptions: ToolbarOptions(
        //removals dont happen
        cut: false,
        paste: false,
        //they may want to copy for some reason
        selectAll: true,
        copy: true,
      ),
      //TODO: what does this do?
      enableInteractiveSelection: true,
      */
      //make pretty
      decoration: InputDecoration(
        //no prefix text (text in front of field) hint does enough
        //no label text (on top of field) hint does enough
        //TODO: use counter or suffix text to indicate if they date is in the past
        //TODO: count also give a month, week, day, kinda ETA
        //After they select a due date they will know what this is
        hintText: "Tap To Select Due Date",
        //snow error when needed
        errorText: (widget.showError.value ? tab + errorText : null),
        //override by error
        helperText: tab + (helperText),
        //match sytling
        prefixIcon: Icon(
          Icons.calendar_today,
          //highlight a bit since it is required
          color: widget.showError.value ? Colors.red : lbGreen,
        ),
        //date field has no selection or focus so dont show it
        border: standardBorder,
        focusedBorder: standardBorder,
        enabledBorder: standardBorder,
        disabledBorder: standardBorder,
        //NOTE: we allow the error to show by changing the border to red
        //errorBorder: standardBorder,
      ),
    );
  }
}

List<String> idToWeekday = [
  "", //since weekday starts at 1
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

List<String> idToMonth = [
  "", //since weekday starts at 1
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

//"weekday, month day, year at 0:00pm";
String ourDateTimeFormat(DateTime dateTime) {
  String dateTimeString = idToWeekday[dateTime.weekday] + ", ";
  dateTimeString += idToMonth[dateTime.month] + " ";
  dateTimeString += dateTime.day.toString() + ", ";
  dateTimeString += dateTime.year.toString() + " at ";
  dateTimeString += ourTimeFormat(dateTime);
  return dateTimeString;
}

String ourTimeFormat(DateTime dateTime){
  String timeString = "";

  //adjust for military time
  //and add am pm
  int hour = dateTime.hour;
  String suffix = " AM";
  if (hour == 0) {
    suffix = " MID";
  }
  if (hour == 12) {
    suffix = " NOON";
  }
  if (hour > 12) {
    hour -= 12;
    suffix = " PM";
  }

  String minutes = dateTime.minute.toString();
  bool add0 = minutes.length != 2;

  //add time
  timeString += hour.toString() + ":";
  timeString += (add0 ? "0" : "");
  timeString += minutes + "";
  timeString += suffix;
  return timeString;
}