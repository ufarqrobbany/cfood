import 'dart:async';

import 'package:cfood/utils/common.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

class ServiceLocation {
  void initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        // notificationTitle: 'Location Service',
        // notificationText: 'Running in Background...',
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
      ),
    );

    service.startService();
  }

  void onStart(ServiceInstance service) async {
    Timer.periodic(const Duration(seconds: 45), (timer) async {
      if (service is AndroidServiceInstance) {
        service.on('stopService').listen((event) {
          service.stopSelf();
        });
      }

      // fetch notification
      // Cek dan minta izin lokasi
      if (await Permission.location.request().isGranted) {
        // Timer untuk melakukan pembaruan lokasi setiap interval tertentu
        service.on('updateLocation').listen((event) async {
          await loadUserLocation();
        });

        // Mulai mendapatkan lokasi setiap 10 menit (600000 ms)
        Timer.periodic(const Duration(milliseconds: 900), (timer) async {
          service.invoke('updateLocation');
        });
      } else {
        log('Location permission denied');
      }
    });
  }

  Future<void> loadUserLocation() async {
    try {
      Position userPosition = await _determinePosition();
      log('User Location: ${userPosition.latitude}, ${userPosition.longitude}');
      // Lakukan sesuatu dengan lokasi user
      UserLocation.DATA.addAll({
        "id": 3,
        "type": '',
        "name": "",
        "menu": "",
        "harga": "",
        "lokasi": LatLng(userPosition.latitude, userPosition.longitude),
      });
      log(UserLocation.DATA.toString());
    } catch (e) {
      log('Failed to determine position: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Service are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}
