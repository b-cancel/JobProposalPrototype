import 'package:google_maps_flutter/google_maps_flutter.dart';

class LineItem {
  String description;
  double materialsCost;
  double laborCost;
  //TODO: make this functional later
  List images = new List();

  LineItem({
    this.description: "",
    this.materialsCost: 0,
    this.laborCost: 0,
  });
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