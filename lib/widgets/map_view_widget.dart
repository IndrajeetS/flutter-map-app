import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_app/global/genrate_random_colors.dart';
import 'package:flutter_map_app/widgets/icon_button_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({super.key});

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  // -------------------------------------------------------
  // Controller for Google Map
  // -------------------------------------------------------
  final _controller = Completer<GoogleMapController>();

  // -------------------------------------------------------
  // Empty List for PolyLines & Pointer/Markers
  // -------------------------------------------------------
  List<Polyline> polylines = [];
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _loadPolylinesFromGeoJSON();
    _loadMarkersFromGeoJSON();
  }

  // -------------------------------------------------------
  // Function to naviagte Map Camera position to Hotel
  // -------------------------------------------------------
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: mapType,
          initialCameraPosition: _kTheGrandNeelam,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          polylines: Set<Polyline>.of(polylines),
          markers: Set<Marker>.of(markers),
        ),
        listOfButtons(),
        Positioned(
          top: 10,
          right: 10,
          child: IconButtonWidget(
            icon: Icons.hotel_outlined,
            tooltip: "The Grand Neelam",
            onPressed: () => _goToHotel(),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------
  // List of nutton to update Map Type
  // -------------------------------------------------------
  listOfButtons() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButtonWidget(
              icon: Icons.map_outlined,
              tooltip: "Normal type",
              onPressed: () {
                setState(() {
                  mapType = MapType.normal;
                });
              },
            ),
            SizedBox(height: 5),
            IconButtonWidget(
              icon: Icons.satellite,
              tooltip: "Satellite type",
              onPressed: () {
                setState(() {
                  mapType = MapType.satellite;
                });
              },
            ),
            SizedBox(height: 5),
            IconButtonWidget(
              icon: Icons.terrain,
              tooltip: "Terrain type",
              onPressed: () {
                setState(() {
                  mapType = MapType.terrain;
                });
              },
            ),
            SizedBox(height: 5),
            IconButtonWidget(
              icon: Icons.map_outlined,
              tooltip: "Hybrid type",
              onPressed: () {
                setState(() {
                  mapType = MapType.hybrid;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // Function to naviagte Map Camera position to Hotel
  // -------------------------------------------------------
  _goToHotel() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_kTheGrandNeelam),
    );
  }

  static const CameraPosition _kTheGrandNeelam = CameraPosition(
    target: LatLng(21.2303433937654, 81.68540358245465),
    bearing: 192.8334901395799,
    tilt: 59.440717697143555,
    zoom: 19,
  );

  // -------------------------------------------------------
  // Function to load Polylines from GeoJson File
  // -------------------------------------------------------
  Future<void> _loadPolylinesFromGeoJSON() async {
    try {
      final geojsonString =
          await rootBundle.loadString('assets/new/polylines.geojson');
      final geojsonData = json.decode(geojsonString);
      final features = geojsonData['features'] as List<dynamic>;
      for (final feature in features) {
        final geometryType = feature['geometry']['type'] as String;
        if (geometryType == 'LineString') {
          final List<dynamic> coordinates = feature['geometry']['coordinates'];
          final latLngs =
              coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
          final polyline = Polyline(
            points: latLngs,
            polylineId: PolylineId(
              "${feature['properties']['description']} + ${Random().nextInt(100)}",
            ),
            color: getRandomColor(),
            width: 4,
            jointType: JointType.round,
          );
          polylines.add(polyline);
        }
      }
      setState(() {});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -------------------------------------------------------
  // Function to load Markers from GeoJson File
  // -------------------------------------------------------
  Future<void> _loadMarkersFromGeoJSON() async {
    try {
      final geojsonString =
          await rootBundle.loadString('assets/new/markers.geojson');
      final geojsonData = json.decode(geojsonString);
      final features = geojsonData['features'] as List<dynamic>;
      for (final feature in features) {
        final geometryType = feature['geometry']['type'] as String;
        if (geometryType == 'Point') {
          final List<dynamic> coordinates = feature['geometry']['coordinates'];
          final latLngs = LatLng(coordinates[1], coordinates[0]);
          final marker = Marker(
            markerId: MarkerId(feature['properties']['Name']),
            position: latLngs,
            infoWindow: InfoWindow(
              title: feature['properties']['Name'],
              snippet: feature['properties']['description'],
            ),
          );
          markers.add(marker);
        }
      }
      setState(() {});
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
