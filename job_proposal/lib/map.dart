//dart
import 'dart:async';

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:google_maps_flutter/google_maps_flutter.dart';

//TODO: grab the latitude and longitude using an API that returns it for each address
//TODO: if the address changes to something with no latitude and longitude then dont show the map
//NOTE: these two changes are primarily for the widget that wraps the map
class MapOfAddress extends StatefulWidget {
  //TODO: pass the lat long and update the map if it changes
  //TODO: assert that the passed lat long are valid

  MapOfAddress({
    @required this.addressTarget,
  });

  final ValueNotifier<LatLng> addressTarget;

  @override
  _MapOfAddressState createState() => _MapOfAddressState();
}

class _MapOfAddressState extends State<MapOfAddress> {
  Completer<GoogleMapController> _controller = Completer();

  //snap to house address if change is detected
  @override
  void initState() {
    super.initState();
    widget.addressTarget.addListener(snapToAddress);
  }

  @override
  void dispose() {
    widget.addressTarget.removeListener(snapToAddress);
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
          },
          //location marker
          markers: {
            Marker(
              markerId: MarkerId("Address"),
              flat: false, //map manipulation doesn't manipulate it
              position: widget.addressTarget.value,
            )
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

  defaultCameraPosition() {
    return CameraPosition(
      target: widget.addressTarget.value,
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
