import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izzup/Services/location.dart';

import '../../Models/globals.dart';
import '../../Models/map_location.dart';
import '../../Services/api.dart';
import '../CompanyDetail/company_detail.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LocationService locationService = LocationService();

  String mapTheme = '';

  int currentCard = 0;

  MapLocation selectedLocation = MapLocation.basic;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final List<Marker> _markers = <Marker>[];

  bool showMessages = false;

  List<MapLocation> _locations = <MapLocation>[];

  @override
  void initState() {
    _getLocations();
    DefaultAssetBundle.of(context)
        .loadString("assets/map_theme.json")
        .then((value) {
      mapTheme = value;
    });
    LocationService.getLocation().then((value) => {
          if (value != null && value != Globals.locationData)
            {
              setState(() {
                Globals.locationData = value;
              })
            }
        });
    super.initState();
  }

  void _getLocations() async {
    _locations = (await Api.jobOffersInRange())!;
    for (final location in _locations) {
      print(location.company.name);
    }
    print(Globals.locationData?.latLng);
    getMarkers();
  }

  void messageTransition(MapLocation currentShownCard) {
    if (currentCard == currentShownCard.company.id) {
      setState(() {
        showMessages = !showMessages;
      });
    } else {
      setState(() {
        selectedLocation = currentShownCard;
        currentCard = currentShownCard.company.id;
        showMessages = true;
      });
    }
  }

  void getMarkers() async {
    Marker marker = Marker(
      markerId: const MarkerId("user"),
      position: Globals.locationData?.latLng ?? _kGooglePlex.target,
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/grey_marker.png"),
    );
    setState(() {
      _markers.add(marker);
    });
    for (final location in _locations) {
      Marker marker = Marker(
        markerId: MarkerId(location.company.id.toString()),
        position: LatLng(location.latitude, location.longitude),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/green_marker.png"),
        onTap: () {
          messageTransition(location);
        },
      );
      setState(() {
        _markers.add(marker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
                target: Globals.locationData?.latLng ?? _kGooglePlex.target,
                zoom: 16),
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(mapTheme);
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(_markers),
          ),
          AnimatedPositioned(
            bottom: showMessages ? 20 : -150,
            left: 20,
            right: 20,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'https://googleflutter.com/sample_image.jpg',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          height: 60,
                          width: 60,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedLocation.company.name,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  selectedLocation
                                      .company.jobOffers[0].jobTitle,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Image(
                          image: AssetImage("assets/stars.png"),
                          height: 30,
                          width: 80,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CompanyPage( company: selectedLocation.company,)),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF00B096)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            child: const Text(
                              "Apply",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
