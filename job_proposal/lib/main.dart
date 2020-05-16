//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:flutter_icons/flutter_icons.dart';

//internal
import 'package:job_proposal/body.dart';
import 'package:job_proposal/data/imaginaryData.dart';
import 'package:job_proposal/data/structs.dart';

//colors extracted form website
Color lbGreen = Color(0xFF00AE65);
Color lbBlue = Color(0xFF00A6DB);
Color lbGrey = Color(0xFFC7C7C7);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //building widgets
    return MaterialApp(
      title: 'Job Order/Proposal',
      theme: ThemeData.light().copyWith(
        accentColor: lbGreen,
      ),
      //NOTE: seperate [JobForm] so we can use mediaquery to grab status bar height
      home: JobForm(
        //TODO: actually grab names and addresses
        clientData: imaginaryClientData,
      ),
    );
  }
}

class JobForm extends StatelessWidget{
  JobForm({
    @required this.clientData,
  });

  final ClientData clientData;

  //we assume proprosal since the is the main goal
  static final ValueNotifier<bool> isOrder = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    //App bar is 56, this should be slightly smaller to take less attention
    double toggleButtonHeight = 48;

    //build
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FormBody(
              //NOTE: must grab status bar height from here
              statusBarHeight: MediaQuery.of(context).padding.top,
              entireScreenHeight: MediaQuery.of(context).size.height,
              toggleButtonHeight: toggleButtonHeight,
              //data
              clientData: clientData,
            ),
          ),
          Material(
            color: lbGrey,
            child: InkWell(
              //order <-> proposal toggle
              onTap: () {
                JobForm.isOrder.value = !JobForm.isOrder.value;
              },
              child: Container(
                height: toggleButtonHeight,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: Icon(
                        //OPS: exchagne, sync, retweet
                        FontAwesome5Solid.sync,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      child: AnimatedBuilder(
                        animation: JobForm.isOrder,
                        builder: (context, child) {
                          if (JobForm.isOrder.value) {
                            return Text("Change Into A Proposal");
                          } else {
                            return Text("Change Into An Order");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}