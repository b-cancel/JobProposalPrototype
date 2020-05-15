//flutter
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_proposal/map.dart';

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
    return MaterialApp(
      title: 'Job Proposal',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ValueNotifier<bool> isOrder = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    //TODO: replace with actual address switch
    //TODO: make sure the address switch resets to null when changing the client name
    ValueNotifier<LatLng> addressTarget = ValueNotifier<LatLng>(
      LatLng(26.278420, -98.180090),
    );

    //building widgets
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lbGreen,
        leading: BackButton(
          onPressed: (){
            print("I'll be back");
          },
        ),
        title: AnimatedBuilder(
          animation: isOrder,
          builder: (BuildContext context, Widget child){
            String formType = isOrder.value ? "Order" : "Proposal";
            return Text("New Job " + formType);
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation){
          //you can't afford the extra space to always show the map
          if(orientation == Orientation.landscape){
            return Center(
              child: Text("To Be Implemented"),
            );
          }
          else{ //you can afford the extra space
            


            return MapOfAddress(
              addressTarget: addressTarget,
            );
          }
        },
      )
    );
  }
}