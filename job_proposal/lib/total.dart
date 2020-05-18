import 'package:flutter/material.dart';
import 'package:job_proposal/data/structs.dart';
import 'package:job_proposal/main.dart';

//NOTE: we know that this is disposed of
//and a new one is rebuilt
//if anything is added or removed from line items
class DisplayTotal extends StatefulWidget {
  DisplayTotal({
    @required this.lineItems,
  });

  final ValueNotifier<List<LineItem>> lineItems;

  @override
  _DisplayTotalState createState() => _DisplayTotalState();
}

class _DisplayTotalState extends State<DisplayTotal> {
  //the updater for every change of an ammount
  updateState(){
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < widget.lineItems.value.length; i++){
      LineItem aLineItem = widget.lineItems.value[i];
      aLineItem.cost.addListener(updateState);
    }
  }

  @override
  void dispose() { 
    for(int i = 0; i < widget.lineItems.value.length; i++){
      LineItem aLineItem = widget.lineItems.value[i];
      aLineItem.cost.removeListener(updateState);
    }
    super.dispose();
  }

  //live total updates
  @override
  Widget build(BuildContext context) {
    int total = 0;
    for(int i = 0; i < widget.lineItems.value.length; i++){
      LineItem aLineItem = widget.lineItems.value[i];
      total += aLineItem.cost.value;
    }

    //build
    return Visibility(
      //in case for some reason they want to do a job for free
      visible: widget.lineItems.value.length > 0,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: 24,
            bottom: 0,
          ),
          child: (total == 0) ? Text(
            "Free Of Charge",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ) : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Total ",
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
              Text(
                "\$" + total.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoricAmmount extends StatelessWidget {
  const CategoricAmmount({
    Key key,
    @required this.onLeft,
    @required this.description,
    @required this.ammount,
  }) : super(key: key);

  final bool onLeft;
  final String description;
  final int ammount;

  @override
  Widget build(BuildContext context) {
    BorderSide stdBorderSide = BorderSide(
      width: 1,
      color: lbGrey,
    );

    //build
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: onLeft ? stdBorderSide : BorderSide.none,
          left: onLeft ? BorderSide.none : stdBorderSide,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 24,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: 8,
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                "\$" + ammount.toString() + " ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}