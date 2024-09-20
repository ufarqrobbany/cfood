import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/screens/maps.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Map<String, dynamic> newDataLocation = {
    'id': 0,
    'name': '',
    'latitude': 0,
    'longitude': 0,
    'floor_count': 0,
    'floor': [
      {
        'floor': 0,
        'room_count': 0,
        'rooms': [
          {
            'room_id': 0,
            'room_name': '',
          }
        ],
      },
    ],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: Text(
          'Lokasi',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: Stack(
        children: [
          MapsScreen(
            showAppbar: false,
            newDataLocation: newDataLocation,
            onLocationChanged: (updatedLocation) {
              setState(() {
                newDataLocation = updatedLocation;
              });
              log('Data Lokasi Terupdate: $newDataLocation');
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.50,
              decoration: BoxDecoration(
                color: Warna.pageBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      newDataLocation['name'].toString(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
