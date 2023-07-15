import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../util/lugar.dart';
import '../services/firebase_services.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LocationData? currentLocation;
  List<Lugar> lugaresCercanos = [];

  void getCurrentLocation() {
    Location location = Location();

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        this.currentLocation = currentLocation;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    lugaresCercanos = []; // Inicializar la lista vacía

    getLugaresFromFirebase().then((lugares) {
      setState(() {
        //lugaresCercanos = lugares;
        //Ejemplo con coordenadas puestas en plaza de los heroes, dsps borrar
        Map<String, double> ubi = {
          'latitud': -34.170311,
          'longitud': -70.740843,
        };
        Lugar lugarEjemplo = Lugar(
            nombre: "Plaza de los Heroes",
            historia:
                "La Plaza de los Héroes de Rancagua es la plaza más importante de esta ciudad",
            valoracion: 3,
            valoraciones: [],
            ubicacion: ubi);
        lugaresCercanos.add(lugarEjemplo);
      });
    });
  }

  Set<Marker> _getMarkers() {
    return lugaresCercanos.map((lugar) {
      return Marker(
        markerId: MarkerId(lugar.nombre),
        position:
            LatLng(lugar.ubicacion['latitud'], lugar.ubicacion['longitud']),
        infoWindow: InfoWindow(
          title: lugar.nombre,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: Text("Loading"),
            )
          : GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
                zoom: 18,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _getMarkers(),
            ),
    );
  }
}
