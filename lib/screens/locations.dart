import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/screens/maps.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Map<String, dynamic>? newDataLocation;
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
              // height: MediaQuery.of(context).size.height * 0.50,
              decoration: BoxDecoration(
                color: Warna.pageBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Lokasi antar anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Warna.biru,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  newDataLocation['name'] == ''
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Pilih salah satu gedung yang ada pada map sebagai lokasi antar!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListTile(
                          tileColor: Warna.abu.withOpacity(0.20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            newDataLocation['name'].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              log('hapus lokasi antar');
                              setState(() {
                                newDataLocation = {
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
                              });
                            },
                            icon: Icon(
                              UIcons.regularRounded.trash,
                              size: 18,
                              color: Warna.like,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
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
