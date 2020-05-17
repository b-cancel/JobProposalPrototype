//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';

//internal
import 'package:job_proposal/body.dart';
import 'package:job_proposal/main.dart';

//widget
MaterialColor getMaterialColor(Color color){
  return MaterialColor(
    0xFF + color.red + color.green + color.blue,
    getColorMap(color.red, color.green, color.blue),
  );
}

Map<int, Color> getColorMap(int red, int green, int blue){
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

selectDateTimeAndroid(
  BuildContext context, 
  {
    @required DateTime firstDate,
    @required DateTime lastDate,
    @required ValueNotifier<DateTime> selectedDate,
    double borderRadius: 0,
    bool barrierDismissible: true,
  }
) async {
  //the theme for both pop ups
  ThemeData themeForPopUps = ThemeData(
    //color of buttons
    //A.K.A. ThemeData.dark().scaffoldBackgroundColor,
    //A.K.A. Color(0xFF303030),
    primarySwatch: getMaterialColor(lbGreen),
    //circle highlight
    accentColor: Theme.of(context).accentColor,
    //banner color
    primaryColor: Theme.of(context).accentColor,
    //color of text inside circle highlight
    /*
    accentTextTheme: TextTheme(
      bodyText1: TextStyle(
        color: ThemeData.dark().scaffoldBackgroundColor,
      ),
    ),
    */
  );

  //set actual date time
  DateTime initialDateTime = selectedDate.value;
  if (isDateNull(initialDateTime)) {
    initialDateTime = DateTime.now();
  }

  //pick date
  DateTime datePicked = await showRoundedDatePicker(
    context: context,
    //options
    initialDatePickerMode: DatePickerMode.day,
    barrierDismissible: barrierDismissible,
    borderRadius: borderRadius,
    //dates
    initialDate: initialDateTime,
    firstDate: firstDate,
    lastDate: lastDate,
    //styling
    description: "Due Date",
    theme: themeForPopUps,
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
    //alternative option button
    textActionButton: "Select Time",
    onTapActionButton: (){

    },
  );



  /*
  //pick time
  TimeOfDay selectedTime = await showRoundedTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
    theme: themeForPopUps,
    barrierDismissible: barrierDismissible,
    borderRadius: 0,
    leftBtn: "Change Date",
    onLeftBtn: () async {
      

      //update the selected date
      if(datePicked != null){
        selectedDate.value = datePicked;
      }
    }
  );
  */

  //if they didn't pick a date they didn't pick a time
  if(selectedDate != null){ //we selected a date
  /*
    //construct the new date time
    //may not include a date

    //date wasn't change
    if(selectedDate.value == initialDate){
      return DateTime(
        //use last date
        initialDate.year,
        initialDate.month,
        initialDate.day,
        //use this time
        selectedTime.hour,
        selectedTime.minute,
      );
    } else {
      return DateTime(
        //use this date
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        //use this time
        selectedTime.hour,
        selectedTime.minute,
      );
    }
    */
  } //use last date and time
}