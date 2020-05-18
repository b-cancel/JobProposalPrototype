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
      aLineItem.laborCost.addListener(updateState);
      aLineItem.materialsCost.addListener(updateState);
    }
  }

  @override
  void dispose() { 
    for(int i = 0; i < widget.lineItems.value.length; i++){
      LineItem aLineItem = widget.lineItems.value[i];
      aLineItem.laborCost.removeListener(updateState);
      aLineItem.materialsCost.removeListener(updateState);
    }
    super.dispose();
  }

  //live total updates
  @override
  Widget build(BuildContext context) {
    int laborTotal = 225;
    int materialsTotal = 50;
    for(int i = 0; i < widget.lineItems.value.length; i++){
      LineItem aLineItem = widget.lineItems.value[i];
      laborTotal += aLineItem.laborCost.value;
      materialsTotal += aLineItem.materialsCost.value;
    }
    int total = laborTotal + materialsTotal;

    //build
    return Visibility(
      //in case for some reason they want to do a job for free
      visible: widget.lineItems.value.length > 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            //IF we only have 1 its obvious where our prices come from
            visible: laborTotal != 0 && materialsTotal != 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: lbGrey,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: CategoricAmmount(
                      onLeft: true,
                      description: "Labor", 
                      ammount: laborTotal,
                    ),
                  ),
                  Expanded(
                    child: CategoricAmmount(
                      onLeft: false,
                      description: "Materials", 
                      ammount: materialsTotal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: 24,
                bottom: 0,
              ),
              child: Row(
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
          )
        ],
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