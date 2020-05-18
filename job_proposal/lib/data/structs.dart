import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//available image item id
int nextAvailableImageLocationID = 0;
class ImageLocation {
  int id;
  String location;

  ImageLocation(
    String initialLocation,
  ){
    this.location = initialLocation;
    this.id = nextAvailableImageLocationID;
    nextAvailableImageLocationID++;
  }
}

//available line item id
int nextAvailableLineItemID = 0;
class LineItem {
  int id;
  //if the LCC wants to be plain and simple this will be sent
  String description = "What we agreed on";
  //simplification of just using dollars,
  //but thats all you need for most scenarios
  ValueNotifier<int> cost = new ValueNotifier<int>(0);
  //used only for UI
  FocusNode descriptionFocusNode = new FocusNode();
  FocusNode costFocusNode = new FocusNode();
  //if we add or remove an image we first need to make copy of this
  //then add the image to the copy
  //then set this.value = copy
  //that way the horizontal list showing all the images knows to update
  ValueNotifier<List<ImageLocation>> imageLocations = new ValueNotifier<List<ImageLocation>>(
    new List<ImageLocation>(),
  );

  LineItem() {
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
