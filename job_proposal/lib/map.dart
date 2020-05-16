//dart
import 'dart:async';

//flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//plugins
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_proposal/data/structs.dart';

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

  Completer<GoogleMapController> _controller = Completer();
  ValueNotifier<int> selectedAddressIndex;

  @override
  void initState() {
    super.initState();

    //init notifier
    selectedAddressIndex = new ValueNotifier<int>(
      widget.clientData.primaryClientAddressIndex,
    );

    //upon new address selection update as needed
    selectedAddressIndex.addListener(snapToAddress);
  }

  @override
  void dispose() {
    selectedAddressIndex.removeListener(snapToAddress);
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
          scrollGesturesEnabled:
              true, //address is plugging in and selected in other ways
          //details
          trafficEnabled: true,
          buildingsEnabled: true,
          //remove creepy featues
          indoorViewEnabled: false,
          //requried
          initialCameraPosition: defaultCameraPosition(),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            controller.showMarkerInfoWindow(markerId);
          },
          //location marker
          markers: {
            Marker(
              markerId: markerId,
              flat: false, //map manipulation doesn't manipulate it
              position: getCurrentAddress().latLng,
              visible: true,
              infoWindow: InfoWindow(
                title: getCurrentAddress().address,
                snippet:  getCurrentAddress().city + ", " + getCurrentAddress().state,
              ),
            ),
          },
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

  AddressData getCurrentAddress(){
    return widget.clientData.addresses[
      selectedAddressIndex.value
    ];
  }

  defaultCameraPosition() {
    return CameraPosition(
      target: getCurrentAddress().latLng,
      //TODO: determine tight zoom based on the size of the property at these coordinates
      //NOTE: currently this was select to show entirety of most houses
      //on and S10 through experimentation
      //19 shows about 3 large houses across an s10's width
      zoom: 20,
    );
  }

  snapToAddress() {
    toAddress(withAnimation: false);
  }

  toAddress({bool withAnimation: true}) async {
    final GoogleMapController controller = await _controller.future;
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
