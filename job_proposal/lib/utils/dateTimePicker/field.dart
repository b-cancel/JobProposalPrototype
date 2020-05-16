import 'package:flutter/material.dart';
import 'package:job_proposal/utils/dateTimePicker/androidPicker.dart';

//widget
class CustomDateTimePicker extends StatefulWidget {

  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  static Duration oneDay = const Duration(days: 1);
  static Duration oneYear = oneDay * 365;
  static Duration humanLifeTime = oneYear * 100;

  //update due date
  ValueNotifier<DateTime> dueDate;

  @override
  void initState() {
    super.initState();

    //next day is the fastest I can imagine it to be done in most cases
    dueDate = new ValueNotifier<DateTime>(
      DateTime.now().add(oneDay),
    );
  }

  //build
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: ()async{
        selectDateTime(
          context, 
          dueDate.value,
          DateTime.now().subtract(
            oneYear,
          ), 
          DateTime.now().add(
            humanLifeTime,
          ), 
        );
      },
        child: Text("tested dt pick"),
    );
  }
}