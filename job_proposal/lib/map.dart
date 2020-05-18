//dart
import 'dart:async';

//flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//plugins
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_proposal/data/structs.dart';
import 'package:job_proposal/main.dart';

//NOTE: we assume the address contain latidue and longitude values
class MapOfAddress extends StatefulWidget {
  MapOfAddress({
    @required this.clientData,
  });

  final ClientData clientData;

  @override
  _MapOfAddressState createState() => _MapOfAddressState();
}

class _MapOfAddressState extends State<MapOfAddress> {
  final MarkerId markerId = MarkerId("Address");

  //completes after map init
  Completer<GoogleMapController> completer;
  //grabed after completer completes
  GoogleMapController mapController;
  //initialized below
  ValueNotifier<int> selectedAddressIndex;

  //open info window and refocus when address changes
  focusOnNewAddress() {
    showInfoWindowForSelectedAddress();
    snapToSelectedAddress();
  }

  @override
  void initState() {
    super.initState();

    //inits
    completer = Completer<GoogleMapController>();
    selectedAddressIndex = new ValueNotifier<int>(
      widget.clientData.primaryClientAddressIndex,
    );

    //upon new address selection update as needed
    selectedAddressIndex.addListener(focusOnNewAddress);
  }

  @override
  void dispose() {
    selectedAddressIndex.removeListener(focusOnNewAddress);
    super.dispose();
  }

  //show map with animate to location button
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //TODO: when the target changes this should only regenarate the markers
        //I may just be able to regenerate it
        //and save myself the hassle of manually snapping to the location
        //like I am doing above with the listeners
        GoogleMap(
          //edit so it works with a sliver app bar
          gestureRecognizers: [
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          ].toSet(),
          //NOTE: for our purposes no other modes show enough info
          mapType: MapType.hybrid,
          //tools
          compassEnabled: true,
          mapToolbarEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          //gestures
          rotateGesturesEnabled: true,
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          //details
          trafficEnabled: true,
          buildingsEnabled: true,
          //remove creepy featues
          indoorViewEnabled: false,
          //requried
          initialCameraPosition: defaultCameraPosition(),
          onMapCreated: (GoogleMapController controller) {
            completer.complete(controller);
            mapController = controller;
            showInfoWindowForSelectedAddress();
          },
          //location marker
          markers: List.generate(
            widget.clientData.addresses.length,
            (int index) {
              AddressData thisAddress = widget.clientData.addresses[index];
              return Marker(
                //guaranteed unique
                markerId: getMarkerID(thisAddress),
                //map manipulation doesn't manipulate it
                //it isn't painted on the map, its on the map
                flat: false,
                //on tap switch to avoid misconceptions
                //only one label will be visible at a time
                //the label is essentially the seleted address initially
                //so it should stay the selected address throughout
                onTap: (){
                  selectedAddressIndex.value = index;
                }, 
                //position
                position: thisAddress.latLng,
                //bring ups address switching options
                infoWindow: InfoWindow(
                  title: thisAddress.address,
                  snippet: thisAddress.city + ", " + thisAddress.state,
                  onTap: () {
                    changeAddressSelected(context);
                  },
                ),
              );
            },
          ).toSet(),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () => toAddress(),
              mini: true,
              child: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future changeAddressSelected(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.clientData.addresses.length,
          itemBuilder: (context, index) {
            AddressData thisAddress = widget.clientData.addresses[index];
            bool selectedIndex = index == selectedAddressIndex.value;
            FontWeight weight =
                selectedIndex ? FontWeight.bold : FontWeight.normal;
            return ListTile(
              onTap: () {
                //update value
                selectedAddressIndex.value = index;

                //remove modal
                Navigator.of(context).pop();
              },
              title: Text(
                thisAddress.address,
                style: TextStyle(
                  fontWeight: weight,
                  color: Colors.black,
                ),
              ),
              trailing: Text(
                thisAddress.city + ", " + thisAddress.state,
                style: TextStyle(
                  fontWeight: weight,
                  color: ThemeData.dark().cardColor,
                ),
              ),
            );
          },
        );
      },
    );
  }

  //TODO: cover case where for some reason an duplicate address is added
  MarkerId getMarkerID(AddressData address) {
    return MarkerId(address.latLng.toString());
  }

  AddressData getCurrentAddress() {
    return widget.clientData.addresses[selectedAddressIndex.value];
  }

  defaultCameraPosition() {
    return CameraPosition(
      target: getCurrentAddress().latLng,
      //TODO: determine tight zoom based on the size of the property at these coordinates
      //NOTE: currently this was select to show entirety of most houses
      //on and S10 through experimentation
      //19 shows about 1 house and the edge of 2 others 
      //on an s10's widths and the selected SMALLER height
      //so that the field would be visible when autofocusing
      zoom: 19,
    );
  }

  showInfoWindowForSelectedAddress() {
    mapController.showMarkerInfoWindow(
      getMarkerID(
        widget.clientData.addresses[selectedAddressIndex.value],
      ),
    );
  }

  snapToSelectedAddress() {
    toAddress(withAnimation: false);
  }

  toAddress({bool withAnimation: true}) async {
    final GoogleMapController controller = await completer.future;
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
      defaultCameraPosition(),
    );

    //snap if the address changed
    if (withAnimation) {
      controller.animateCamera(cameraUpdate);
    } else {
      controller.moveCamera(cameraUpdate);
    }
  }
}
