import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//available line item id
int nextAvailableLineItemID = 0;
class LineItem {
  int id;
  //if the LCC wants to be plain and simple this will be sent
  String description = "Agreed On Yard Work";
  //simplification, but all thats needed for most scenarios
  ValueNotifier<int> materialsCost = new ValueNotifier<int>(0);
  ValueNotifier<int> laborCost = new ValueNotifier<int>(0);
  //used only for UI
  FocusNode focusNode = new FocusNode();
  //TODO: make this functional later
  List images = new List();

  LineItem(){
    this.id = nextAvailableLineItemID;
    nextAvailableLineItemID++;
  }
}

class ClientData {
  String name;
  List<AddressData> addresses;
  int primaryClientAddressIndex;

  ClientData(
    this.name,
    this.addresses,
    this.primaryClientAddressIndex,
  );
}

class AddressData {
  LatLng latLng;
  String address;
  String city;
  String state;

  AddressData(
    this.latLng,
    this.address,
    this.city,
    this.state,
  );
}