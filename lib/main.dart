import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentAddress = 'My Adress';
  Position? currentPosition;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please Keep Location turned on");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location Permission denies.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Permission is denied forever.");
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentPosition = position;
        currentAddress =
            '${place.locality},${place.postalCode},${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }

  // void initState() {
  //   currentPosition = {"latitude:${1.2222}, Longitude: ${2.22222}"} as Position;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GeoLocation"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(currentAddress),
            TextButton(
                onPressed: () {
                  _determinePosition();
                },
                child: const Text("Locate Me")),
            currentPosition != null
                ? Text('Latitude= ${currentPosition?.latitude}')
                : Container(),
            currentPosition != null
                ? Text('Longitude= ${currentPosition?.longitude}')
                : Container(),
          ],
        ),
      ),
    );
  }
}
// lat: 28.6895549, log: 77.1310887