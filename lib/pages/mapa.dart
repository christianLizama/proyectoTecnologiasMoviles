import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../services/firebase_services.dart';
import '../util/lugar.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String mapStyle = '';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LocationData? currentLocation;
  List<Lugar> lugaresCercanos = [];

  Location location = Location();
  bool locationEnabled = false;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Solicitar al usuario que encienda la ubicación
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // El usuario no encendió la ubicación, puedes mostrar un mensaje o tomar otra acción aquí.
        return;
      }
    }

    // Verificar si se concedió el permiso de ubicación
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // Solicitar al usuario el permiso de ubicación
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // El usuario no otorgó el permiso de ubicación, puedes mostrar un mensaje o tomar otra acción aquí.
        return;
      }
    }

    // Obtener la ubicación actual
    LocationData? currentLocation = await location.getLocation();
    setState(() {
      this.currentLocation = currentLocation;
      locationEnabled = true;
    });
  }

  @override
  void initState() {
    super.initState();

    lugaresCercanos = []; // Inicializar la lista vacía

    getLugaresFromFirebase().then((lugares) {
      setState(() {
        lugaresCercanos = lugares;
        lugaresCercanos[0].printValues();
      });
    });

    getCurrentLocation();

    DefaultAssetBundle.of(context)
        .loadString('assets/map/map_style.json')
        .then((value) {
      mapStyle = value;
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
      body: locationEnabled
          ? GoogleMap(
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
                controller.setMapStyle(mapStyle);
                _controller.complete(controller);
              },
              markers: _getMarkers(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No se puede acceder a tu ubicación actual.",
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: getCurrentLocation,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
    );
  }
}
