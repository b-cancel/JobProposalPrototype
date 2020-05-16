
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';

Future<DateTime> selectDateTime(
  BuildContext context, 
  DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  { //options
    double borderRadius: 0,
    bool barrierDismissible: true,
  }
) async {
  Map<int, Color> color = {
    50: Color.fromRGBO(30, 30, 30, 1),
    100: Color.fromRGBO(30, 30, 30, 1),
    200: Color.fromRGBO(30, 30, 30, 1),
    300: Color.fromRGBO(30, 30, 30, 1),
    400: Color.fromRGBO(30, 30, 30, 1),
    500: Color.fromRGBO(30, 30, 30, 1),
    600: Color.fromRGBO(30, 30, 30, 1),
    700: Color.fromRGBO(30, 30, 30, 1),
    800: Color.fromRGBO(30, 30, 30, 1),
    900: Color.fromRGBO(30, 30, 30, 1),
  };

  //the theme for both pop ups
  ThemeData themeForPopUps = ThemeData(
    //color of buttons
    //A.K.A. ThemeData.dark().scaffoldBackgroundColor,
    //A.K.A. Color(0xFF303030),
    primarySwatch: MaterialColor(0xFF303030, color),
    //circle highlight
    accentColor: Theme.of(context).accentColor,
    //banner color
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    //color of text inside circle highlight
    /*
    accentTextTheme: TextTheme(
      bodyText1: TextStyle(
        color: ThemeData.dark().scaffoldBackgroundColor,
      ),
    ),
    */
  );

  //updated by everything down the chain
  ValueNotifier<DateTime> selectedDate = new ValueNotifier<DateTime>(initialDate);

  //pick date
  DateTime datePicked = await showRoundedDatePicker(
    context: context,
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
    //dates
    initialDate: selectedDate.value,
    firstDate: firstDate,
    lastDate: lastDate,
    /*
    Color background, 
    String textNegativeButton, 
    String textPositiveButton, 
    String textActionButton, 
    void Function() onTapActionButton, 
    MaterialRoundedDatePickerStyle styleDatePicker, 
    MaterialRoundedYearPickerStyle styleYearPicker, 
    List<String> customWeekDays, 
    Widget Function(DateTime, bool, 
    bool, TextStyle) builderDay, 
    List<DateTime> listDateDisabled, 
    bool Function(DateTime, bool) onTapDay
    */
    //options
    initialDatePickerMode: DatePickerMode.day,
    barrierDismissible: barrierDismissible,
    borderRadius: borderRadius,
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
  else return initialDate;
}