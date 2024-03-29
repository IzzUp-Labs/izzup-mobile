import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/scale.dart';
import 'package:izzup/Services/location.dart';
import 'package:izzup/Services/navigation.dart';

import '../../Models/globals.dart';
import '../../Models/map_location.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';
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
  late GoogleMapController mapController;
  late String cardPhoto = 'https://googleflutter.com/sample_image.jpg';

  String mapTheme = '';

  MapLocation selectedLocation = MapLocation.basic;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final List<Marker> _markers = <Marker>[];

  bool showMessages = false;

  List<MapLocation> _locations = <MapLocation>[];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

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

  bool _reloadLoading = false;

  void reload() async {
    setState(() {
      _reloadLoading = true;
    });
    setState(() {
      _markers.removeWhere((element) => element.markerId != const MarkerId("user"));
    });
    _getLocations();
    await LocationService.getLocation().then((value) => {
      if (value != null && value != Globals.locationData) {
        setState(() {
          Globals.locationData = value;
          if (Globals.locationData != null) {
            mapController.animateCamera(
                CameraUpdate.newLatLngZoom(
                    LatLng(
                        Globals.locationData!.latitude!,
                        Globals.locationData!.longitude!
                    ),
                    16
                ));
          }
        })
      }
    });
    setState(() {
      showMessages = false;
      _reloadLoading = false;
    });
  }

  void _getLocations() async {
    var fetchedLocations = (await Api.jobOffersInRange())!;
    setState(() => _locations = fetchedLocations);
    getMarkers();
  }

  void messageTransition(MapLocation currentShownCard) async {
    var googlePhoto = await Api.getPlacePhotoLinks(currentShownCard.company.placeId);
    if (selectedLocation.isEquals(currentShownCard)) {
      setState(() {
        showMessages = !showMessages;
      });
    } else {
      setState(() {
        if( googlePhoto != null) {
          cardPhoto = googlePhoto.first;
        }
        selectedLocation = currentShownCard;
        showMessages = true;
      });
    }
  }

  void getMarkers() async {
    final Uint8List greyMarkerBytes = await getBytesFromAsset('assets/grey_marker.png', 75);
    final Uint8List greenMarkerBytes = await getBytesFromAsset('assets/green_marker.png', 75);
    Marker marker = Marker(
      markerId: const MarkerId("user"),
      position: Globals.locationData?.latLng ?? _kGooglePlex.target,
      icon: BitmapDescriptor.fromBytes(greyMarkerBytes),
    );
    setState(() {
      _markers.add(marker);
    });
    for (final location in _locations) {
      Marker marker = Marker(
        markerId: MarkerId(location.company.id.toString()),
        position: LatLng(location.latitude, location.longitude),
        icon: BitmapDescriptor.fromBytes(greenMarkerBytes),
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
              mapController = controller;
            },
            markers: Set<Marker>.of(_markers),
          ),
          AnimatedPositioned(
            bottom: showMessages ? 20 : -150,
            left: 20,
            right: 20,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onVerticalDragDown: (dragDownDetails) {
                setState(() => showMessages = false);
              },
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
                            cardPhoto,
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
                                context.push(CompanyPage(
                                    company: selectedLocation.company));
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF00B096)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              child: Text(
                                AppLocalizations.of(context)?.map_apply ??
                                    "Apply",
                                style: const TextStyle(
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
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () { reload(); },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.accent,
                    fixedSize: Size(MediaQuery.of(context).size.width / 4, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // <-- Radius
                    ),
                  ),
                  child: _reloadLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: ClassyLoader(
                              loaderColor: AppColors.accent,
                              loaderSize: 5,
                              loaderBackground: Colors.transparent))
                      : Text(
                    AppLocalizations.of(context)?.map_reload ?? "Reload",
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
