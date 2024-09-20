import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/repository/routing_navigation/direction_controller.dart';
import 'package:cfood/repository/routing_navigation/direction_layer.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:uicons/uicons.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';
// import 'package:web_browser/web_browser.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class MapsScreen extends StatefulWidget {
  bool showAppbar;
  Map<String, dynamic>? newDataLocation;
  final Function(Map<String, dynamic> updatedLocation)? onLocationChanged;
  MapsScreen({
    super.key,
    this.showAppbar = true,
    this.newDataLocation,
    this.onLocationChanged,
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  List<Map<String, dynamic>> dataOrder = [
    {
      "id": 1,
      "type": 'pembeli',
      "name": "Pembeli 1",
      "menu": "roti bakar",
      "harga": "10000",
      "lokasi": const LatLng(-6.869821, 107.572844),
    },
    {
      "id": 2,
      "type": 'penjual',
      "name": "Penjual",
      "menu": "roti bakar",
      "harga": "10000",
      // "lokasi": const LatLng(-6.870937, 107.572546),
      "lokasi": const LatLng(-6.870870, 107.571301)
    },
    // {
    //   "id": 3,
    //   "type": 'kurir',
    //   "name": "kurir",
    //   "menu": "roti bakar",
    //   "harga": "10000",
    //   "lokasi": const LatLng(-6.872503, 107.572476),
    //   // "lokasi": const LatLng(-6.871736, 107.574984)
    // },
  ];

  List<Map<String, dynamic>> buildingData = [
    {
      'id': 1,
      'name': 'Polban gedung 1',
      'latitude': -6.871372,
      'longitude': 107.571951,
      'floor_count': 2,
      'floor': [
        {
          'floor': 1,
          'room_count': 2,
          'rooms': [
            {
              'room_id': 11,
              'room_name': 'ruangan 1',
            },
            {
              'room_id': 12,
              'room_name': 'ruangan 2',
            },
          ],
        },
        {
          'floor': 2,
          'room_count': 2,
          'rooms': [
            {
              'room_id': 21,
              'room_name': 'ruangan 1',
            },
            {
              'room_id': 22,
              'room_name': 'rungan 2',
            }
          ],
        },
      ],
    },
    {
      'id': 2,
      'name': 'Polban Gedung 2',
      'latitude': -6.870211,
      'longitude': 107.571948,
      'floor_count': 1,
      'floor': [
        {
          'floor': 1,
          'room_count': 1,
          'rooms': [
            {
              'room_id': 1,
              'room_name': 'iugkjblkglkjlbkj',
            }
          ],
        },
      ],
    },
    {
      'id': 3,
      'name': 'Gedung Polban 2',
      'latitude': -6.871412,
      'longitude': 107.574021,
      'floor_count': 1,
      'floor': [
        {
          'floor': 1,
          'room_count': 1,
          'rooms': [
            {
              'room_id': 1,
              'room_name': 'rungangan knlkjbnkjnlkjn',
            }
          ],
        },
      ],
    },
  ];
  List<LatLng> coordinates = [
    const LatLng(-6.869821, 107.572844),
    const LatLng(-6.870937, 107.572546),
  ];
  final List<DirectionCoordinate> _coordinates = [
    DirectionCoordinate(-6.869821, 107.572844),
    DirectionCoordinate(-6.870937, 107.572546)
  ];
  Map<String, LatLng> nodes = {};
  List<List<String>> ways = [];
  final MapController _mapController = MapController();
  final DirectionController _directionController = DirectionController();

  get xml => null;

  @override
  void initState() {
    // WebViewPlatform.instance()
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    super.initState();
    log("data lokasi user local : ${UserLocation.DATA}");
    loadUserLocation();
  }

  // Future<void> checkLocationPermission() async {
  //   if (await Permission.location.isGranted) {
  //     loadUserLocation();
  //   } else {
  //     // Meminta izin lokasi
  //     final permissionStatus = await Permission.location.request();
  //     if (permissionStatus.isGranted) {
  //       loadUserLocation();
  //     } else {
  //       log('Location permission denied');
  //     }
  //   }
  // }

  Future<void> loadUserLocation() async {
    if (await Permission.location.isGranted) {
      try {
        Position userPosition = await _determinePosition();
        log("lokasi user : $userPosition");

        if (userPosition.latitude.abs() <= 90.0 &&
            userPosition.longitude.abs() <= 180.0) {
          dataOrder.add(
            {
              "id": 3,
              "type": 'kurir',
              "name": "kurir",
              "menu": "roti bakar",
              "harga": "10000",
              "lokasi": LatLng(userPosition.latitude, userPosition.longitude),
            },
          );
          log('Data order added: $dataOrder');
          _loadNewRoute();
        } else {
          log('Invalid location coordinates: ${userPosition.latitude}, ${userPosition.longitude}');
        }
      } catch (e) {
        log('Failed to determine position: $e');
      }
    } else {
      log('Location permission denied or not granted yet');
    }
  }

  void _loadNewRoute() async {
    log(dataOrder.toString());
    // Menambahkan semua lokasi dari dataOrder ke dalam _coordinates
    _coordinates.addAll(
      dataOrder.map((order) {
        final lokasi = order['lokasi'] as LatLng;
        return DirectionCoordinate(lokasi.latitude, lokasi.longitude);
      }).toList(),
    );

    // Membuat bounds untuk menyesuaikan peta dengan koordinat yang baru
    final bounds = LatLngBounds.fromPoints(
      _coordinates
          .map((location) => LatLng(location.latitude, location.longitude))
          .toList(),
    );

    // Menyesuaikan peta dengan batas koordinat
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );

    // Mengupdate rute di controller
    _directionController
        .updateDirection(_coordinates.cast<DirectionCoordinate>());

    // Logging untuk debug
    log(_directionController.toString());
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
      return Future.error('Location Persmission Denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission Are Permanently Denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  void addNewLocation() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.showAppbar
          ? null
          : AppBar(
              leading: backButtonCustom(context: context),
              leadingWidth: 90,
              // backgroundColor: Colors.white.withOpacity(0.10),
              // foregroundColor: Colors.white.withOpacity(0.10),
              // scrolledUnderElevation: 100,
              elevation: 0,
              forceMaterialTransparency: false,
              actions: [
                notifIconButton(
                  icons: UIcons.solidRounded.loading,
                  iconColor: Warna.biru,
                  notifCount: '0',
                  onPressed: () {
                    loadUserLocation();
                  },
                )
              ],
            ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(-6.871451, 107.572846), // Koordinat default
          initialZoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],

            // attributionBuilder: (_) {
            //   return Text("© OpenStreetMap contributors");
            // },
          ),
          DirectionsLayer(
            coordinates: _coordinates,
            color: Warna.hijau.withOpacity(0.80),
            onCompleted: (isRouteAvailable) {
              log(isRouteAvailable.toString());
            },
            controller: _directionController,
          ),
          MarkerLayer(
              markers: buildingData.map((building) {
            return Marker(
              point: LatLng(building['latitude'], building['longitude']),
              child: InkWell(
                onTap: () {
                  log(building['name'].toString());
                  log(building['floor'].toString());
                  log(building['floor'][0]['rooms'].toString());
                  showMyCustomDialog(
                    context,
                    barrierDismissible: true,
                    text: building['name'].toString(),
                    content: buildingMenu(
                      floorData: building['floor'],
                      buildingItem: building,
                    ),
                    customActions: [],
                  );
                },
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    // Icons.location_city_rounded,
                    UIcons.solidRounded.building,
                    color: Warna.hijau,
                    size: 20,
                  ),
                ),
              ),
            );
          }).toList()),
          MarkerLayer(
            markers: dataOrder.map((coord) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: coord['lokasi'],
                child: InkWell(
                  onTap: () {
                    log(coord['type']);
                  },
                  child: coord['type'] == 'pembeli'
                      ? Icon(
                          Icons.person_pin_circle_rounded,
                          color: Warna.like,
                          size: 28,
                        )
                      : coord['type'] == 'penjual'
                          ? Icon(
                              Icons.store_mall_directory_rounded,
                              color: Warna.kuning,
                              size: 28,
                            )
                          : coord['type'] == 'kurir'
                              ? Icon(
                                  Icons.directions_bike_rounded,
                                  color: Warna.like,
                                  size: 28,
                                )
                              : Icon(
                                  Icons.directions_bike_rounded,
                                  color: Warna.biru,
                                  size: 28,
                                ),
                ),
                // builder: (ctx) => Icon(Icons.location_on, color: Colors.red),
              );
            }).toList(),
          ),
          // MarkerLayer(
          //   markers: coordinates.map((coord) {
          //     return Marker(
          //       width: 80.0,
          //       height: 80.0,
          //       point: coord,
          //       child: Icon(Icons.location_on, color: Warna.like),
          //       // builder: (ctx) => Icon(Icons.location_on, color: Colors.red),
          //     );
          //   }).toList(),
          // ),

          // ),
        ],
      ),
    );
  }

  Widget buildingMenu({
    List<Map<String, dynamic>>? floorData,
    Map<String, dynamic>? buildingItem,
  }) {
    int selectedFloorId = 0;
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).size.height * 0.50,
      child: ListView.builder(
        itemCount: floorData?.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: Text("Lantai ${floorData![index]['floor']}"),
                trailing: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Warna.biru,
                ),
                onTap: () {
                  setState(() {
                    selectedFloorId = floorData[index]['floor'];
                  });
                  log(selectedFloorId.toString());
                  log(floorData[index]['rooms'].toString());
                },
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                // height: 100,
                child: ListView.builder(
                  itemCount: floorData[index]['rooms'].length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, indexRoom) {
                    var room = floorData[index]['rooms'][indexRoom];
                    var selectedRoom = 0;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                      // tileColor: selectedRoom == room['room_id']
                      //     ? Warna.kuning
                      //     : Colors.transparent,
                      title: Text(room['room_name'].toString()),
                      onTap: () {
                        setState(() {
                          selectedRoom = room['room_id'];
                          widget.newDataLocation?.addAll(buildingItem!);

                          if (widget.onLocationChanged != null) {
                            widget.onLocationChanged!(widget.newDataLocation!);
                          }
                        });

                        log(selectedRoom.toString());
                        log(widget.newDataLocation.toString());
                      },
                    );
                  },
                ),
              ),
              Divider(
                color: Warna.biru.withOpacity(0.50),
                height: 1,
                thickness: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}

// Future<void> loadOSMFile() async {
//   try {
//     // Access the OSM file from the uploaded path
//     // final directory = await getApplicationDocumentsDirectory();
//     // final filePath =
//     //     '${directory.path}/map.osm'; // Adjust the path accordingly
//     final file = File('assets/maps/map.osm');

//     // Ensure file is copied to the app's documents directory (if not there already)
//     if (!await file.exists()) {
//       // Copy from assets to the app documents folder
//       final byteData = await File('assets/maps/map.osm').readAsBytes();
//       await file.writeAsBytes(byteData);
//     }

//     // Reading file content
//     final content = await file.readAsString();

//     // Parse XML content from OSM file
//     final document = xml.parse(content);

//     // Extract all nodes from the OSM file
//     final nodeElements = document.findAllElements('node');
//     for (var node in nodeElements) {
//       final id = node.getAttribute('id') ?? '';
//       final lat = double.parse(node.getAttribute('lat') ?? '0');
//       final lon = double.parse(node.getAttribute('lon') ?? '0');
//       nodes[id] = LatLng(lat, lon);
//     }

//     // Extract ways that connect nodes
//     final wayElements = document.findAllElements('way');
//     for (var way in wayElements) {
//       List<String> wayNodes = [];
//       final ndElements = way.findAllElements('nd');
//       for (var nd in ndElements) {
//         final nodeId = nd.getAttribute('ref') ?? '';
//         wayNodes.add(nodeId);
//       }
//       ways.add(wayNodes);
//     }

//     // Initialize with the coordinates of the first way
//     if (ways.isNotEmpty) {
//       coordinates = ways[0].map((id) => nodes[id]!).toList();
//     }

//     // Update the UI to display the route
//     setState(() {});
//   } catch (e) {
//     log("Error loading OSM file: $e");
//   }
// }

// if (coordinates.isNotEmpty)
//   PolylineLayer(
//     polylines: [
//       Polyline(
//         points: coordinates,
//         strokeWidth: 4.0,
//         color: Colors.blue,
//       ),
//     ],
//   ),
// PolylineLayer(
//   polylines: [
//     Polyline(
//       points: coordinates,
//       strokeWidth: 4.0,
//       color: Colors.blue,
//     ),
//   ],

// body: SfMaps(
//   layers: [
//     MapTileLayer(
//       initialFocalLatLng: MapLatLng(-6.871451, 107.572846),
//       initialZoomLevel: 15,
//       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//       sublayers: [
//         MapPolylineLayer(
//           polylines: Set.of([MapPolyline(
//             points: polylinePoints,
//           )]),
//         ),
//       ],
//       initialMarkersCount: 2,
//       markerBuilder: (context, index) {
//         if (index == 0) {
//           return MapMarker(
//               iconColor: Colors.white,
//               iconStrokeColor: Colors.blue,
//               iconStrokeWidth: 2,
//               latitude: polylinePoints[index].latitude,
//               longitude: polylinePoints[index].longitude);
//         }
//         return MapMarker(
//             iconColor: Colors.white,
//             iconStrokeColor: Colors.blue,
//             iconStrokeWidth: 2,
//             latitude: polylinePoints[polylinePoints.length - 1].latitude,
//             longitude: polylinePoints[polylinePoints.length - 1].longitude);
//       },
//     ),
//   ],
// ),

//  WebViewController controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000))
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onHttpError: (HttpResponseError error) {},
//       onWebResourceError: (WebResourceError error) {},
//       onNavigationRequest: (NavigationRequest request) {
//         if (request.url.startsWith('https://www.youtube.com/')) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     ),
//   )
//   ..loadRequest(Uri.parse('https://www.openstreetmap.org/export#map=17/-6.871509/107.575518'));
