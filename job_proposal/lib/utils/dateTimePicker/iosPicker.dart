import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:job_proposal/body.dart';

selectDateTimeIOS(
  BuildContext context, {
  @required DateTime firstDate,
  @required DateTime lastDate,
  //NOTE: if this is equal to the nullDateTime we simply assume DateTime.now()
  @required ValueNotifier<DateTime> selectedDate,
}) {
  //set actual date time
  DateTime initialDateTime = selectedDate.value;
  if (isDateNull(initialDateTime)) {
    initialDateTime = DateTime.now();
  }

  //show picker
  DatePicker.showDatePicker(
    context,
    locale: DateTimePickerLocale.en_us,
    pickerMode: DateTimePickerMode.datetime,
    //EEE and MMM for short
    dateFormat: "EEE, MMMM d, yyyy at H:mm",
    //dates
    minDateTime: firstDate,
    initialDateTime: initialDateTime,
    maxDateTime: lastDate,
    //function
    onConfirm: (DateTime newDateTime, List<int> someNumbers){
      if(areDatesEqual(newDateTime, initialDateTime) == false){
        print("updating date time");
        selectedDate.value = newDateTime;
      }
      else{
        print("not updating date time");
      }
    },
  );
}
