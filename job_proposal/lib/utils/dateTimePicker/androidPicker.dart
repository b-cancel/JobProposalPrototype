//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';

//internal
import 'package:job_proposal/body.dart';
import 'package:job_proposal/main.dart';
import 'package:job_proposal/utils/dateTimePicker/field.dart';

//pop up styling
ThemeData themeForPopUps = ThemeData(
  //color of buttons
  //A.K.A. ThemeData.dark().scaffoldBackgroundColor,
  //A.K.A. Color(0xFF303030),
  primarySwatch: getMaterialColor(lbGreen),
  //circle highlight
  accentColor: lbGreen,
  //banner color
  primaryColor: lbGreen,
  //color of text inside circle highlight
  /*
  accentTextTheme: TextTheme(
    bodyText1: TextStyle(
      color: ThemeData.dark().scaffoldBackgroundColor,
    ),
  ),
  */
);

MaterialColor getMaterialColor(Color color) {
  return MaterialColor(
    color.value,
    getColorMap(color.red, color.green, color.blue),
  );
}

Map<int, Color> getColorMap(int red, int green, int blue) {
  Color theColor = Color.fromRGBO(red, green, blue, 1);
  return {
    50: theColor,
    100: theColor,
    200: theColor,
    300: theColor,
    400: theColor,
    500: theColor,
    600: theColor,
    700: theColor,
    800: theColor,
    900: theColor,
  };
}

//selector
selectDateTimeAndroid(
  BuildContext context, {
  @required DateTime firstDate,
  @required DateTime lastDate,
  @required ValueNotifier<DateTime> selectedDate,
}) async {
  //set actual date time
  ValueNotifier<DateTime> dtToUpdate = new ValueNotifier<DateTime>(
    selectedDate.value,
  );
  if (isDateNull(dtToUpdate.value)) {
    dtToUpdate.value = DateTime.now();
  }

  //we grab the date returned to determine if the user
  //either agreed to keep the change
  //or decided to revert
  changeDateTime(
    context,
    essentiallyReturn: selectedDate,
    dtWithLastSavedTime: dtToUpdate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
}

//TODO: more consistent behavior
//I can update the date on the fly
//EX: I can update the time date, then open the time picker and keep that date
//BUT... I can't to the same thing for the time given the limits of the plugin

//For both of the very confusing functions below
//the dateToUpdate is updated instantly
//when a change is made to either date or time
//---
//specifically to the date portion for the date picker
//AND specifically to the time portion for the time picker

//CASE 1: this is so that if we open the other type of picker
//which implies we close the one that was open
//the date or time that we selected in this picker gets transfered over to the other picker

//CASE 2: if we don't open another picker we need to read what the picker returned
//because the user may have canceled their selection

//date picker than lets you change time
//TODO: fix issues or switch plugins
//if you use the change year UI
//and then you pick a time
//without first tapping a day
//the year change will be lost
//this is probably never if rarely going to be an issue
changeDateTime(
  BuildContext context, {
  //has the right time
  @required ValueNotifier<DateTime> essentiallyReturn,
  @required ValueNotifier<DateTime> dtWithLastSavedTime,
  @required DateTime firstDate,
  @required DateTime lastDate,
  //other
  double borderRadius: 0,
  bool barrierDismissible: true,
}) async {
  DateTime result = await showRoundedDatePicker(
    context: context,
    //options
    initialDatePickerMode: DatePickerMode.day,
    barrierDismissible: barrierDismissible,  
    //dates
    initialDate: dtWithLastSavedTime.value,
    firstDate: firstDate,
    lastDate: lastDate,
    //styling
    theme: themeForPopUps,
    borderRadius: borderRadius,
    description: "Due Date",
    textNegativeButton: "Cancel",
    textPositiveButton: "AT " + ourTimeFormat(
      dtWithLastSavedTime.value,
    ),
    styleYearPicker: MaterialRoundedYearPickerStyle(
      textStyleYearSelected: TextStyle(
        fontWeight: FontWeight.bold,
        color: ThemeData.dark().primaryColorDark,
        fontSize: 36,
      ),
      textStyleYear: TextStyle(
        fontWeight: FontWeight.normal,
        color: ThemeData.dark().primaryColorLight,
        fontSize: 24,
      ),
    ),
    //instant update
    onTapDay: (DateTime newDate, bool boolean) {
      DateTime oldTime = dtWithLastSavedTime.value;

      //only grab new date (don't touch time)
      dtWithLastSavedTime.value = getDateTimeFrom2(
        hasDate: newDate,
        hasTime: oldTime,
      );

      //meets some unknown function requirement
      return true;
    },
    //alternative option button
    textActionButton: "Change Time",
    onTapActionButton: () async {
      //pop ourselves and
      //pass the responsibility to the next picker to return
      Navigator.of(context).pop();

      //call the next picker
      changeTime(
        context,
        essentiallyReturn: essentiallyReturn,
        //NOTE: the right year may not be passed here
        //see TODO above this function for explanation
        dtWithLastSavedDate: dtWithLastSavedTime,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    },
  );

  //If you open up the time picker, that will return instead
  //otherwise we return here

  //we don't need to update the result with dateToUpdate
  //since the result is basically the LAST value dateToUpdate was set to
  //IF the user didn't cancel operations

  //null if the user canceled operations
  if(result != null){ //NOTE: the picker only updates the date
    //but in doing so it resets the time
    //so combine the two values
    //NOTE: you might be tempted to just use dtWithLastSavedTime
    //but that isn't updated when the year is changed from the change year UI
    essentiallyReturn.value = getDateTimeFrom2(
      hasTime: dtWithLastSavedTime.value,
      hasDate: result,
    );
  }
}

//time picker that lets you change date
changeTime(
  BuildContext context, {
  //has the right date
  @required ValueNotifier<DateTime> essentiallyReturn,
  @required ValueNotifier<DateTime> dtWithLastSavedDate,
  @required DateTime firstDate,
  @required DateTime lastDate,
  //other
  double borderRadius: 0,
  bool barrierDismissible: true,
}) async {
  //change the time
  TimeOfDay selectedTime = await showRoundedTimePicker(
    context: context,
    //options
    barrierDismissible: barrierDismissible,
    //times
    initialTime: TimeOfDay.fromDateTime(
      dtWithLastSavedDate.value,
    ),
    //styling
    theme: themeForPopUps,
    borderRadius: 0,
    //negativeBtn: "Cancel",
    //positiveBtn: "SELECT",
    //alternative option button

    //NOTE: this option was eliminated since 
    //if we go to change the date, our time will not be saved
    //but if we are changing date, and go to time our our date will be saved
    //to produce less confusing behavior we only allow the date picker to open up the time picker
    //and not the time picker to open up the date picker

    /*
    leftBtn: "Change Date",
    onLeftBtn: () async {
      //update the selected date
      if (datePicked != null) {
        selectedDate.value = datePicked;
      }
    },
    */
  );

  //If you open up the date picker, that will return instead
  //otherwise we return here

  //we don't need to update the result with dateToUpdate
  //since the result is basically the LAST value dateToUpdate was set to
  //IF the user didn't cancel operations

  //null if the user canceled operations
  if (selectedTime != null){
    //merge the new time with the old date
    essentiallyReturn.value = getDateTimeFrom2(
      hasDate: dtWithLastSavedDate.value,
      //we must full with dummy data given postitional parameters
      hasTime: DateTime(
        0, //year
        0, //month
        0, //day
        selectedTime.hour,
        selectedTime.minute,
      ),
    );
  }
}

DateTime getDateTimeFrom2({DateTime hasDate, DateTime hasTime}) {
  return DateTime(
    //date
    hasDate.year,
    hasDate.month,
    hasDate.day,
    //time
    hasTime.hour,
    hasTime.minute,
  );
}