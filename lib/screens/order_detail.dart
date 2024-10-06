import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/model/cancel_order_response.dart';
import 'package:cfood/model/confirm_cart_response.dart';
import 'package:cfood/model/create_order_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/repository/routing_navigation/direction_controller.dart';
import 'package:cfood/screens/chat.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/maps.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/screens/rate_screen.dart';
import 'package:cfood/screens/wirausaha_pages/main.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class OrderDetailScreen extends StatefulWidget {
  final String? status;
  final int? merchantId;
  final int? cartId;
  final DataOrder? dataOrder;
  final int? orderId;

  final String noteOrder;
  final String orderNumber;
  final String orderTime;
  final String paymentMethod;
  final bool fromConfirm;
  final bool isOwner;
  const OrderDetailScreen({
    super.key,
    this.status,
    this.merchantId,
    this.cartId,
    this.orderId,
    this.noteOrder = '',
    this.orderNumber = '',
    this.orderTime = '',
    this.paymentMethod = '',
    this.dataOrder,
    this.fromConfirm = true,
    this.isOwner = false,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  ConfirmCartResponse? confirmCartResponse;
  DataConfirmCart? dataConfirmCart;
  String currentStatus = '';
  String paymentMethod = '';
  DataOrder? dataOrderResponse;
  bool isPop = false;
  final List<Map<String, dynamic>> orderStatusProses = [
    {
      'status': 'Dikonfirmasi',
      'time': '00.00',
      'done': true,
      'onProgress': false,
    },
    {
      'status': 'Diproses',
      'time': '00.00',
      'done': true,
      'onProgress': false,
    },
    {
      'status': 'Diantar',
      'time': '00.00',
      'done': false,
      'onProgress': true,
    },
    {
      'status': 'Selesai',
      'time': '00.00',
      'done': false,
      'onProgress': false,
    },
  ];

  Map<String, dynamic> driverInfo = {
    'id': '0000',
    'profile': '/.jpg',
    'name': 'Kusen DanaAtamaya',
    'rate': '5.0',
    'notification': 7,
  };

  Map<String, dynamic> orderStatusInfoData = {
    'id': '0',
    'store': 'nama toko',
    'type': 'Kantin',
    'selected': true,
    'status': 'Belum Bayar',
    'menu': [
      {
        'id': '1',
        'name': 'nama menu',
        'image': '/.jpg',
        'price': 10000,
        'count': 1,
        'variants': ['coklat', 'susu', 'tiramusi'],
      },
      {
        'id': '1',
        'name': 'nama menu',
        'image': '/.jpg',
        'price': 10000,
        'count': 2,
        'variants': ['coklat', 'tiramusi'],
      },
    ],
  };

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

  List<Map<String, dynamic>> dataOrder = [];
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

  @override
  void initState() {
    super.initState();
    setState(() {
      currentStatus = widget.status!;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    if (widget.fromConfirm) {
      setState(() {
        dataOrderResponse = widget.dataOrder;
        currentStatus = dataOrderResponse!.status.toString();
        paymentMethod = dataOrderResponse!.paymentMethod.toString();
      });
    } else {
      fetchDetail();
    }
  }

  Future<void> fetchDetail() async {
    log('order id : ${widget.orderId}');
    CreateOrderResponse response = await FetchController(
      endpoint: 'orders/detail/${widget.orderId}',
      fromJson: (json) => CreateOrderResponse.fromJson(json),
    ).getData();

    if (response.statusCode == 200) {
      setState(() {
        dataOrderResponse = response.data;
        currentStatus = dataOrderResponse!.status.toString();
        paymentMethod = dataOrderResponse!.paymentMethod.toString();
      });
    }
  }

  void cancelOrder(BuildContext context) {
    int orderId = 0;
    if (widget.orderId == null) {
      setState(() {
        orderId = dataOrderResponse!.id!;
      });
    } else {
      setState(() {
        orderId = widget.orderId!;
      });
    }

    showMyCustomDialog(context,
        text: 'Apakah Anda yakin untuk membatalkan pesanan?',
        noText: 'Tidak',
        yesText: 'Ya',
        colorYes: Warna.like,
        colorNO: Warna.abu, onTapYes: () async {
      CancelOrderResponse response = await FetchController(
          endpoint: 'orders/cancel?orderId=$orderId',
          fromJson: (json) => CancelOrderResponse.fromJson(json)).putData({});

      setState(() {
        currentStatus = response.data!.status!;
        log(currentStatus);
      });
      navigateBack(context);
    }, onTapNo: () {
      navigateBack(context);
    });
  }

  void confirmOrder(BuildContext context) async {
    int orderId = 0;
    if (widget.orderId == null) {
      setState(() {
        orderId = dataOrderResponse!.id!;
      });
    } else {
      setState(() {
        orderId = widget.orderId!;
      });
    }
    CancelOrderResponse response = await FetchController(
        endpoint: 'orders/confirm-merchant?orderId=$orderId',
        fromJson: (json) => CancelOrderResponse.fromJson(json)).putData({});

    setState(() {
      currentStatus = response.data!.status!;
      log(currentStatus);
    });
  }

  void rejectOrder(BuildContext context) {
    int orderId = 0;
    if (widget.orderId == null) {
      setState(() {
        orderId = dataOrderResponse!.id!;
      });
    } else {
      setState(() {
        orderId = widget.orderId!;
      });
    }
    showMyCustomDialog(context,
        text: 'Apakah Anda yakin untuk menolak pesanan?',
        noText: 'Tidak',
        yesText: 'Ya',
        colorYes: Warna.like,
        colorNO: Warna.abu, onTapYes: () async {
      CancelOrderResponse response = await FetchController(
          endpoint: 'orders/reject?orderId=$orderId',
          fromJson: (json) => CancelOrderResponse.fromJson(json)).putData({});

      setState(() {
        currentStatus = response.data!.status!;
        log(currentStatus);
      });
      navigateBack(context);
    }, onTapNo: () {
      navigateBack(context);
    });
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  int calculateSubtotalCost(Map<String, dynamic> orderData) {
    List<dynamic> menuItems = orderData['menu'];
    int totalPrice = 0;

    for (var item in menuItems) {
      int price = item['price'];
      int count = item['count'];
      totalPrice += price * count;
    }

    return totalPrice;
  }

  int calculateTotalMenuItems(Map<String, dynamic> orderData) {
    List<dynamic> menuItems = orderData['menu'];
    int totalItems = 0;

    for (var item in menuItems) {
      int count = item['count'];
      totalItems += count;
    }

    return totalItems;
  }

  int calculateTotalCost({int? subtotal, int? shipping, int? service}) {
    int totalCost = subtotal! + shipping! + service!;

    return totalCost;
  }

  Future<void> loadUserLocation() async {
    if (await Permission.location.isGranted) {
      try {
        Position userPosition = await _determinePosition();
        log("lokasi user : $userPosition");

        if (userPosition.latitude.abs() <= 90.0 &&
            userPosition.longitude.abs() <= 180.0) {
          dataOrder.add(
            {
              "id": 1,
              "type": 'pembeli',
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

  void goBack(BuildContext context) {
    if (widget.isOwner) {
      log('to order list');
      setState(() {
        isPop = false;
      });
      navigateToRep(
          context,
          const MainScreenMerchant(
            firstIndexScreen: 0,
          ));
    } else {
      if (widget.fromConfirm) {
        log('to order list');
        setState(() {
          isPop = false;
        });
        navigateToRep(
            context,
            MainScreen(
              firstIndexScreen: 2,
            ));
      } else {
        log('back');
        setState(() {
          isPop = false;
        });
        // navigateBack(context);
        navigateToRep(
            context,
            MainScreen(
              firstIndexScreen: 2,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return PopScope(
      canPop: isPop,
      onPopInvoked: (pop) {
        goBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 90,
          leading: backButtonCustom(
              context: context,
              customTap: () {
                goBack(context);
              }),
          title: const Text(
            'Detail Pesanan',
            style: AppTextStyles.title,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        backgroundColor: Colors.white,
        body: bodyContainer(),
        // body: Stack(
        //   children: [
        //      MapsScreen(
        //       showAppbar: false,
        //       newDataLocation: newDataLocation,
        //       userLocation: dataOrder,
        //       onLocationChanged: (updatedLocation) {
        //         setState(() {
        //           newDataLocation = updatedLocation;
        //         });
        //         log('Data Lokasi Terupdate: $newDataLocation');
        //       },
        //     ),

        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: Container(
        //         width: double.infinity,
        //         height: MediaQuery.of(context).size.height * 0.50,
        //         decoration: const BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.vertical(
        //             top: Radius.circular(20),
        //           ),
        //         ),
        //         child: bodyContainer(),
        //       ),
        //     )
        //   ],
        // )
      ),
    );
  }

  Widget bodyContainer() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: dataOrderResponse == null
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  widget.isOwner ? statusContainerSeller() : statusContainer(),
                  // Container(
                  //   height: 130,
                  //   margin: const EdgeInsets.symmetric(vertical: 10),
                  //   child: StatusOrderTimeLineTileWidget(
                  //     processIndex: 0,
                  //     status: '',
                  //     statusListMapData: orderStatusProses,
                  //   ),
                  // ),

                  Divider(
                    height: 10,
                    thickness: 1.5,
                    color: Warna.abu,
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: false,
                    leading: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      child:
                          // dataConfirmCart?.userInformation.userPhoto == null
                          dataOrderResponse?.userInformation?.userPhoto == null
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Warna.abu,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(Icons.person))
                              : Image.network(
                                  "${AppConfig.URL_IMAGES_PATH}${dataOrderResponse?.userInformation?.userPhoto}",
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                    ),
                    title: Text(
                      // dataConfirmCart!.userInformation.userName,
                      dataOrderResponse!.userInformation!.userName.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: dataOrderResponse!
                                .userInformation!.studentInformation ==
                            null
                        ? null
                        : Text(
                            dataOrderResponse!
                                .userInformation!
                                .studentInformation!
                                .studyProgramInformation!
                                .studyProgramName
                                .toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Warna.abu4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 1.5,
                    color: Warna.abu,
                  ),
                  // orderItemBox(),
                  orderItemBox(),

                  orderCalculateCostBox(),

                  boxOrderInfoDetail(),

                  // Container(
                  //   height: 50,
                  //   width: double.infinity,
                  //   margin: const EdgeInsets.symmetric(vertical: 10),
                  //   child: DynamicColorButton(
                  //     onPressed: () {
                  //       navigateTo(context, const OrderConfirmScreen());
                  //     },
                  //     text: 'Bayar',
                  //     backgroundColor: Warna.kuning,
                  //     borderRadius: 54,
                  //   ),
                  // ),
                  // currentStatus == 'pesanan dibuat' ?
                  widget.isOwner
                      ? Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: DynamicColorButton(
                            onPressed: () {
                              navigateTo(
                                context,
                                ChatScreen(
                                  isMerchant: true,
                                  merchantId: 1,
                                  userId: 1,
                                ),
                              );
                            },
                            icon: Icon(
                              UIcons.solidRounded.comment,
                              color: Colors.white,
                            ),
                            text: 'Chat Pembeli',
                            backgroundColor: Warna.kuning,
                            borderRadius: 54,
                          ),
                        )
                      : Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: DynamicColorButton(
                            onPressed: () {
                              navigateTo(
                                context,
                                ChatScreen(
                                  isMerchant: true,
                                  merchantId: 1,
                                  userId: 1,
                                ),
                              );
                            },
                            icon: Icon(
                              UIcons.solidRounded.comment,
                              color: Colors.white,
                            ),
                            text: 'Chat Penjual',
                            backgroundColor: Warna.kuning,
                            borderRadius: 54,
                          ),
                        ),

                  widget.isOwner
                      ? Container()
                      : currentStatus == 'pesanan sudah sampai'
                          ? Container(
                              height: 50,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: DynamicColorButton(
                                onPressed: () {
                                  navigateTo(context, const RateScreen());
                                },
                                text: 'Beri Penilaian',
                                backgroundColor: Warna.kuning,
                                borderRadius: 54,
                              ),
                            )
                          : Container(),

                  // Container(
                  //   height: 50,
                  //   width: double.infinity,
                  //   margin: const EdgeInsets.symmetric(vertical: 10),
                  //   child: DynamicColorButton(
                  //     onPressed: () {},
                  //     text: 'Ubah Metode Pembayaran',
                  //     backgroundColor: Warna.biru,
                  //     borderRadius: 54,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),

                  // SizedBox(height: 100,),
                ],
              ),
            ),
    );
  }

  Widget statusContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        currentStatus == 'MENUNGGU_KONFIRM_PENJUAL'
            ? paymentMethod == 'cash'
                ? const Center(
                    child: Text(
                      'Menunggu Konfirmasi Penjual',
                      style: AppTextStyles.subTitle,
                    ),
                  )
                : const Center(
                    child: Text(
                      'Menunggu Konfirmasi',
                      style: AppTextStyles.subTitle,
                    ),
                  )
            : currentStatus == 'DIPROSES_PENJUAL'
                ? Center(
                    child: Text('Pesanan Dikonfirmasi',
                        // style: AppTextStyles.subTitle,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Warna.hijau)),
                  )
                : currentStatus == 'PESANAN_SAMPAI'
                    ? const Center(
                        child: Text(
                          'Pesanan Sudah Sampai',
                          style: AppTextStyles.subTitle,
                        ),
                      )
                    : currentStatus == 'DIBATALKAN'
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Pesanan Dibatalkan',
                                style: TextStyle(
                                    color: Warna.like,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : currentStatus == 'DITOLAK'
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Pesanan Ditolak Penjual',
                                    style: TextStyle(
                                        color: Warna.like,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : Container(),
        currentStatus == 'BELUM_BAYAR'
            ? Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: DynamicColorButton(
                  onPressed: () {
                    cancelOrder(context);
                  },
                  text: 'Batalkan Pesanan',
                  backgroundColor: Warna.like,
                  borderRadius: 54,
                ),
              )
            : currentStatus == 'PESANAN_SAMPAI'
                ? Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: DynamicColorButton(
                      onPressed: () {},
                      text: 'Konfirmasi Telah Diterima',
                      backgroundColor: Warna.kuning,
                      borderRadius: 54,
                    ),
                  )
                : currentStatus == 'MENUNGGU_KONFIRM_PENJUAL'
                    ? Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: DynamicColorButton(
                          onPressed: () {
                            cancelOrder(context);
                          },
                          text: 'Batalkan Pesanan',
                          backgroundColor: Warna.like,
                          borderRadius: 54,
                        ),
                      )
                    : currentStatus == 'DIPROSES_PENJUAL'
                        ? Container(
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Buat kesepakatan dengan penjual dan tunggu pesananmu diantarkan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Warna.abu4,
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                        : currentStatus == 'PESANAN_SAMPAI'
                            ? Container(
                                height: 50,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: DynamicColorButton(
                                  onPressed: () {},
                                  text: 'Konfirmasi Sudah Diterima',
                                  backgroundColor: Warna.hijau,
                                  borderRadius: 54,
                                ),
                              )
                            : Container(),
      ],
    );
  }

  Widget statusContainerSeller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        currentStatus == 'MENUNGGU_KONFIRM_PENJUAL'
            ? paymentMethod == 'cash'
                ? const Center(
                    child: Text(
                      'Menunggu Konfirmasi Penjual',
                      style: AppTextStyles.subTitle,
                    ),
                  )
                : const Center(
                    child: Text(
                      'Menunggu Konfirmasi',
                      style: AppTextStyles.subTitle,
                    ),
                  )
            : currentStatus == 'DIPROSES_PENJUAL'
                ? const Center(
                    child: Text(
                      'Pesanan Telah Dikonfirmasi',
                      style: AppTextStyles.subTitle,
                    ),
                  )
                : currentStatus == 'PESANAN_SAMPAI'
                    ? const Center(
                        child: Text(
                          'Pesanan Sudah Sampai',
                          style: AppTextStyles.subTitle,
                        ),
                      )
                    : currentStatus == 'DIBATALKAN'
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Pesanan Dibatalkan',
                                style: TextStyle(
                                    color: Warna.like,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : currentStatus == 'DITOLAK'
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Ditolak Oleh Penjual',
                                    style: TextStyle(
                                        color: Warna.like,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : Container(),
        currentStatus == 'BELUM_BAYAR'
            ? Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: DynamicColorButton(
                  onPressed: () {
                    cancelOrder(context);
                  },
                  text: 'Batalkan Pesanan',
                  backgroundColor: Warna.like,
                  borderRadius: 54,
                ),
              )
            : currentStatus == 'PESANAN_SAMPAI'
                ? Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: DynamicColorButton(
                      onPressed: () {},
                      text: 'Konfirmasi Telah Diterima',
                      backgroundColor: Warna.kuning,
                      borderRadius: 54,
                    ),
                  )
                : currentStatus == 'MENUNGGU_KONFIRM_PENJUAL'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.40,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: DynamicColorButton(
                              onPressed: () {
                                // cancelOrder(context);
                                rejectOrder(context);
                              },
                              text: 'Tolak',
                              textColor: Warna.like,
                              backgroundColor: Warna.like.withOpacity(0.05),
                              border: BorderSide(
                                color: Warna.like,
                                width: 1.5,
                              ),
                              borderRadius: 54,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.40,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: DynamicColorButton(
                              onPressed: () {
                                // cancelOrder(context);
                                confirmOrder(context);
                              },
                              text: 'Konfirmasi',
                              backgroundColor: Warna.hijau,
                              borderRadius: 54,
                            ),
                          ),
                        ],
                      )
                    : currentStatus == 'DIPROSES_PENJUAL'
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  child: Text(
                                    'Buat kesepakatan dengan pembeli dan antarkan pesanan.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Warna.abu4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                              Container(
                                height: 45,
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                child: DynamicColorButton(
                                  onPressed: () {
                                    // cancelOrder(context);
                                  },
                                  text: 'Pesanan sudah diantarkan',
                                  backgroundColor: Warna.hijau,
                                  borderRadius: 54,
                                ),
                              ),
                            ],
                          )
                        : currentStatus == 'PESANAN_SAMPAI'
                            ? Container(
                                height: 50,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: DynamicColorButton(
                                  onPressed: () {},
                                  text: 'Konfirmasi Sudah Diterima',
                                  backgroundColor: Warna.hijau,
                                  borderRadius: 54,
                                ),
                              )
                            : Container(),
      ],
    );
  }

  Widget orderItemBox({
    // String? imgUrl,
    int storeListIndex = 0,
    Map<String, dynamic>? storeItem,
    List<Map<String, dynamic>>? menuItems,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Warna.abu,
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                dataOrderResponse!.orderInformation!.merchantInformation!
                            .merchantType ==
                        "WIRAUSAHA"
                    ? CommunityMaterialIcons.handshake
                    : Icons.store,
                color: dataOrderResponse!.orderInformation!.merchantInformation!
                            .merchantType ==
                        "WIRAUSAHA"
                    ? Warna.kuning
                    : Warna.biru,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                dataOrderResponse!
                    .orderInformation!.merchantInformation!.merchantName
                    .toString(),
                // 'nama toko',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
            ],
          ),
          ListView.builder(
            itemCount: dataOrderResponse!
                .orderInformation!.orderItemInformations!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, menuIdx) {
              var item = dataOrderResponse!
                  .orderInformation!.orderItemInformations![menuIdx];
              return Container(
                // height: 100,
                // padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: menuIdx ==
                            dataOrderResponse!.orderInformation!
                                    .orderItemInformations!.length -
                                1
                        ? const BorderSide(
                            color: Colors.transparent, width: 1.5)
                        : BorderSide(color: Warna.abu, width: 1.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: false,
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Warna.abu,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: item.menuInformation.menuPhoto == null
                          ? const Center(
                              child: Icon(Icons.image),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "${AppConfig.URL_IMAGES_PATH}${item.menuInformation.menuPhoto}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Warna.abu,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                },
                              )),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.menuInformation.menuName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${item.quantity}x',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.cartVariantInformations.isEmpty
                            ? ''
                            : getVariantDescription(
                                item.cartVariantInformations)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              Constant.currencyCode +
                                  formatNumberWithThousandsSeparator(
                                      item.totalPriceItem),
                              style: AppTextStyles.productPrice,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          //
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Subtotal ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                  "(${dataOrderResponse!.orderInformation!.totalMenu} Menu | ${dataOrderResponse!.orderInformation!.totalItem} Item)",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Warna.regulerFontColor)),
              const Spacer(),
              Text(
                Constant.currencyCode +
                    formatNumberWithThousandsSeparator(
                        dataOrderResponse!.orderInformation!.subTotalPrice!),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Warna.biru,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget orderCalculateCostBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Warna.abu,
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dataOrderResponse!
                      .orderInformation!.merchantInformation!.merchantType ==
                  "KANTIN"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Biaya Pengiriman',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Warna.regulerFontColor,
                      ),
                    ),
                    Text(
                      "${Constant.currencyCode}${formatNumberWithThousandsSeparator(5000)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Warna.biru,
                      ),
                    )
                  ],
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Layanan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                "${Constant.currencyCode}${formatNumberWithThousandsSeparator(dataOrderResponse!.serviceCost!)}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Warna.biru,
                ),
              )
            ],
          ),
          dataOrderResponse!.voucherCost != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Voucher Diskon',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Warna.regulerFontColor,
                      ),
                    ),
                    Text(
                      "-${Constant.currencyCode}${formatNumberWithThousandsSeparator(dataOrderResponse!.voucherCost!)}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Warna.biru,
                      ),
                    )
                  ],
                )
              : Container(),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Total ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Warna.regulerFontColor,
                ),
              ),
              const Spacer(),
              Text(
                Constant.currencyCode +
                    formatNumberWithThousandsSeparator(
                        dataOrderResponse!.totalPrice!),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Warna.biru,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget boxOrderInfoDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catatan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                // widget.noteOrder != '' ? widget.noteOrder : 'Tidak ada',
                dataOrderResponse!.note != ''
                    ? dataOrderResponse!.note!
                    : 'Tidak ada',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No. Pesanan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // widget.orderNumber != '' ? widget.orderNumber : '',
                    dataOrderResponse!.orderNumber != ''
                        ? dataOrderResponse!.orderNumber!
                        : '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: dataOrderResponse!.orderNumber!),
                      );
                      showToast('Copied');
                    },
                    child: Text(
                      'SALIN',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Warna.kuning,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waktu Pemesanan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                // widget.orderTime != '' ? widget.orderTime : 'date mounth year, time',
                dataOrderResponse!.orderDate != ''
                    ? dataOrderResponse!.orderDate!
                    : '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pembayaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                // widget.paymentMethod != '' ? widget.paymentMethod : 'cash',
                dataOrderResponse!.paymentMethod != ''
                    ? dataOrderResponse!.paymentMethod!
                    : 'cash',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// =======
// import 'package:cfood/custom/CButtons.dart';
// import 'package:cfood/custom/CPageMover.dart';
// import 'package:cfood/custom/order_status_timeline_tile.dart';
// import 'package:cfood/model/confirm_cart_response.dart';
// import 'package:cfood/repository/fetch_controller.dart';
// import 'package:cfood/screens/chat.dart';
// import 'package:cfood/screens/order_confirm.dart';
// import 'package:cfood/screens/rate_screen.dart';
// import 'package:cfood/style.dart';
// import 'package:cfood/utils/common.dart';
// import 'package:cfood/utils/constant.dart';
// import 'package:community_material_icon/community_material_icon.dart';
// import 'package:flutter/material.dart';
// import 'package:uicons/uicons.dart';

// class OrderDetailScreen extends StatefulWidget {
//   final String? status;
//   final int? merchantId;
//   final int? cartId;

//   final String noteOrder;
//   final String orderNumber;
//   final String orderTime;
//   final String paymentMethod;
//   const OrderDetailScreen({
//     super.key,
//     this.status,
//     this.merchantId,
//     this.cartId,
//     this.noteOrder = '',
//     this.orderNumber = '',
//     this.orderTime = '',
//     this.paymentMethod = '',
//   });

//   @override
//   State<OrderDetailScreen> createState() => _OrderDetailScreenState();
// }

// class _OrderDetailScreenState extends State<OrderDetailScreen> {
//   ConfirmCartResponse? confirmCartResponse;
//   DataConfirmCart? dataConfirmCart;
//   String currentStatus = '';
//   final List<Map<String, dynamic>> orderStatusProses = [
//     {
//       'status': 'Dikonfirmasi',
//       'time': '00.00',
//       'done': true,
//       'onProgress': false,
//     },
//     {
//       'status': 'Diproses',
//       'time': '00.00',
//       'done': true,
//       'onProgress': false,
//     },
//     {
//       'status': 'Diantar',
//       'time': '00.00',
//       'done': false,
//       'onProgress': true,
//     },
//     {
//       'status': 'Selesai',
//       'time': '00.00',
//       'done': false,
//       'onProgress': false,
//     },
//   ];

//   Map<String, dynamic> driverInfo = {
//     'id': '0000',
//     'profile': '/.jpg',
//     'name': 'Kusen DanaAtamaya',
//     'rate': '5.0',
//     'notification': 7,
//   };

//   Map<String, dynamic> orderStatusInfoData = {
//     'id': '0',
//     'store': 'nama toko',
//     'type': 'Kantin',
//     'selected': true,
//     'status': 'Belum Bayar',
//     'menu': [
//       {
//         'id': '1',
//         'name': 'nama menu',
//         'image': '/.jpg',
//         'price': 10000,
//         'count': 1,
//         'variants': ['coklat', 'susu', 'tiramusi'],
//       },
//       {
//         'id': '1',
//         'name': 'nama menu',
//         'image': '/.jpg',
//         'price': 10000,
//         'count': 2,
//         'variants': ['coklat', 'tiramusi'],
//       },
//     ],
//   };

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       currentStatus = widget.status!;
//     });
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     if (widget.cartId != null) {
//       fetchConfirmCartByCartId();
//     } else {
//       fetchConfirmCartByMerchantId();
//     }
//   }

//   Future<void> fetchConfirmCartByCartId() async {
//     confirmCartResponse = await FetchController(
//       endpoint: 'carts/confirm?cartId=${widget.cartId}',
//       fromJson: (json) => ConfirmCartResponse.fromJson(json),
//     ).getData();

//     setState(() {
//       dataConfirmCart = confirmCartResponse?.data;
//     });
//   }

//   Future<void> fetchConfirmCartByMerchantId() async {
//     confirmCartResponse = await FetchController(
//       endpoint:
//           'carts/confirm-merchant?userId=${AppConfig.USER_ID}&merchantId=${widget.merchantId}',
//       fromJson: (json) => ConfirmCartResponse.fromJson(json),
//     ).getData();

//     setState(() {
//       dataConfirmCart = confirmCartResponse?.data;
//     });
//   }

//   Future<void> refreshPage() async {
//     await Future.delayed(const Duration(seconds: 10));

//     print('reload...');
//   }

//   int calculateSubtotalCost(Map<String, dynamic> orderData) {
//     List<dynamic> menuItems = orderData['menu'];
//     int totalPrice = 0;

//     for (var item in menuItems) {
//       int price = item['price'];
//       int count = item['count'];
//       totalPrice += price * count;
//     }

//     return totalPrice;
//   }

//   int calculateTotalMenuItems(Map<String, dynamic> orderData) {
//     List<dynamic> menuItems = orderData['menu'];
//     int totalItems = 0;

//     for (var item in menuItems) {
//       int count = item['count'];
//       totalItems += count;
//     }

//     return totalItems;
//   }

//   int calculateTotalCost({int? subtotal, int? shipping, int? service}) {
//     int totalCost = subtotal! + shipping! + service!;

//     return totalCost;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 90,
//         leading: backButtonCustom(context: context),
//         title: const Text(
//           'Detail Pesanan',
//           style: AppTextStyles.title,
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: dataConfirmCart == null
//             ? Container()
//             : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     currentStatus == 'pesanan dibuat'
//                         ? const Center(
//                             child: Text(
//                               'Menunggu Konfirmasi',
//                               style: AppTextStyles.subTitle,
//                             ),
//                           )
//                         : currentStatus == 'pesanan dikonfirmasi'
//                             ? const Center(
//                                 child: Text(
//                                   'Pesanan Dikonfirmasi',
//                                   style: AppTextStyles.subTitle,
//                                 ),
//                               )
//                             : currentStatus == 'pesanan sudah sampai'
//                                 ? const Center(
//                                     child: Text(
//                                       'Pesanan Sudah Sampai',
//                                       style: AppTextStyles.subTitle,
//                                     ),
//                                   )
//                                 : Container(),
//                     currentStatus == 'Belum Bayar'
//                         ? Container(
//                             height: 50,
//                             width: double.infinity,
//                             margin: const EdgeInsets.symmetric(vertical: 20),
//                             child: DynamicColorButton(
//                               onPressed: () {},
//                               text: 'Batalkan Pesanan',
//                               backgroundColor: Warna.like,
//                               borderRadius: 54,
//                             ),
//                           )
//                         : currentStatus == 'selesai'
//                             ? Container(
//                                 height: 50,
//                                 width: double.infinity,
//                                 margin:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 child: DynamicColorButton(
//                                   onPressed: () {},
//                                   text: 'Konfirmasi Telah Diterima',
//                                   backgroundColor: Warna.kuning,
//                                   borderRadius: 54,
//                                 ),
//                               )
//                             : currentStatus == 'pesanan dibuat'
//                                 ? Container(
//                                     height: 50,
//                                     width: double.infinity,
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 20),
//                                     child: DynamicColorButton(
//                                       onPressed: () {},
//                                       text: 'Batalkan Pesanan',
//                                       backgroundColor: Warna.like,
//                                       borderRadius: 54,
//                                     ),
//                                   )
//                                 : currentStatus == 'pesanan dikonfirmasi'
//                                     ? Container(
//                                         height: 50,
//                                         width: double.infinity,
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 20),
//                                         child: Text(
//                                           'Buat kesepakatan dengan penjual dan tunggu pesananmu diantarakan',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: Warna.abu4,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ))
//                                     : currentStatus == 'pesanan sudah sampai'
//                                         ? Container(
//                                             height: 50,
//                                             width: double.infinity,
//                                             margin: const EdgeInsets.symmetric(
//                                                 vertical: 20),
//                                             child: DynamicColorButton(
//                                               onPressed: () {},
//                                               text: 'Konfirmasi Sudah Diterima',
//                                               backgroundColor: Warna.hijau,
//                                               borderRadius: 54,
//                                             ),
//                                           )
//                                         : Container(),
//                     // Container(
//                     //   height: 130,
//                     //   margin: const EdgeInsets.symmetric(vertical: 10),
//                     //   child: StatusOrderTimeLineTileWidget(
//                     //     processIndex: 0,
//                     //     status: '',
//                     //     statusListMapData: orderStatusProses,
//                     //   ),
//                     // ),

//                     Divider(
//                       height: 10,
//                       thickness: 1.5,
//                       color: Warna.abu,
//                     ),

//                     ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       dense: false,
//                        leading: ClipRRect(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(100)),
//                           child:
//                               dataConfirmCart?.userInformation.userPhoto == null
//                                   ?  Container(
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       color: Warna.abu,
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     child: Icon(Icons.person))
//                                   : Image.network(
//                                       "${AppConfig.URL_IMAGES_PATH}${dataConfirmCart!.userInformation.userPhoto}",
//                                       fit: BoxFit.cover,
//                                       width: 40,
//                                       height: 40,
//                                     ),
//                         ),
//                         title: Text(
//                           dataConfirmCart!.userInformation.userName,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         subtitle: dataConfirmCart!.userInformation.studentInformation == null ? null : Text(
//                           dataConfirmCart!.userInformation.studentInformation!
//                               .studyProgramInformation.studyProgramName,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Warna.abu4,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                     ),
//                     Divider(
//                       height: 10,
//                       thickness: 1.5,
//                       color: Warna.abu,
//                     ),
//                     // orderItemBox(),
//                     orderItemBox(),

//                     orderCalculateCostBox(),

//                     boxOrderInfoDetail(),

//                     // Container(
//                     //   height: 50,
//                     //   width: double.infinity,
//                     //   margin: const EdgeInsets.symmetric(vertical: 10),
//                     //   child: DynamicColorButton(
//                     //     onPressed: () {
//                     //       navigateTo(context, const OrderConfirmScreen());
//                     //     },
//                     //     text: 'Bayar',
//                     //     backgroundColor: Warna.kuning,
//                     //     borderRadius: 54,
//                     //   ),
//                     // ),
//                     // currentStatus == 'pesanan dibuat' ?
//                     Container(
//                       height: 50,
//                       width: double.infinity,
//                       margin: const EdgeInsets.symmetric(vertical: 10),
//                       child: DynamicColorButton(
//                         onPressed: () {
//                           navigateTo(
//                             context,
//                             ChatScreen(
//                               isMerchant: true,
//                               merchantId: 1,
//                               userId: 1,
//                             ),
//                           );
//                         },
//                         icon: Icon(
//                           UIcons.solidRounded.comment,
//                           color: Colors.white,
//                         ),
//                         text: 'Chat Penjual',
//                         backgroundColor: Warna.kuning,
//                         borderRadius: 54,
//                       ),
//                     ),

//                     currentStatus == 'pesanan sudah sampai'
//                         ? Container(
//                             height: 50,
//                             width: double.infinity,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             child: DynamicColorButton(
//                               onPressed: () {
//                                 navigateTo(context, const RateScreen());
//                               },
//                               text: 'Beri Penilaian',
//                               backgroundColor: Warna.kuning,
//                               borderRadius: 54,
//                             ),
//                           )
//                         : Container(),

//                     // Container(
//                     //   height: 50,
//                     //   width: double.infinity,
//                     //   margin: const EdgeInsets.symmetric(vertical: 10),
//                     //   child: DynamicColorButton(
//                     //     onPressed: () {},
//                     //     text: 'Ubah Metode Pembayaran',
//                     //     backgroundColor: Warna.biru,
//                     //     borderRadius: 54,
//                     //   ),
//                     // ),
//                     const SizedBox(
//                       height: 15,
//                     ),

//                     // SizedBox(height: 100,),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget orderItemBox({
//     // String? imgUrl,
//     int storeListIndex = 0,
//     Map<String, dynamic>? storeItem,
//     List<Map<String, dynamic>>? menuItems,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         // borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: Warna.abu,
//             width: 1.5,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(
//                 dataConfirmCart!
//                             .cartInformation.merchantInformation.merchantType ==
//                         "WIRAUSAHA"
//                     ? CommunityMaterialIcons.handshake
//                     : Icons.store,
//                 color: dataConfirmCart!
//                             .cartInformation.merchantInformation.merchantType ==
//                         "WIRAUSAHA"
//                     ? Warna.kuning
//                     : Warna.biru,
//                 size: 20,
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               Text(
//                 dataConfirmCart!
//                     .cartInformation.merchantInformation.merchantName,
//                 // 'nama toko',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const Spacer(),
//             ],
//           ),
//           ListView.builder(
//             itemCount:
//                 dataConfirmCart!.cartInformation.cartItemInformations.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, menuIdx) {
//               var item = dataConfirmCart!
//                   .cartInformation.cartItemInformations[menuIdx];
//               return Container(
//                 // height: 100,
//                 // padding: const EdgeInsets.symmetric(vertical: 20),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: menuIdx ==
//                             dataConfirmCart!.cartInformation
//                                     .cartItemInformations.length -
//                                 1
//                         ? const BorderSide(
//                             color: Colors.transparent, width: 1.5)
//                         : BorderSide(color: Warna.abu, width: 1.5),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     dense: false,
//                     leading: Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: Warna.abu,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: item.menuInformation.menuPhoto == null
//                           ? const Center(
//                               child: Icon(Icons.image),
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 "${AppConfig.URL_IMAGES_PATH}${item.menuInformation.menuPhoto}",
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     width: 60,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       color: Warna.abu,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   );
//                                 },
//                               )),
//                     ),
//                     title: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             item.menuInformation.menuName,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           '${item.quantity}x',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         )
//                       ],
//                     ),
//                     subtitle: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.cartVariantInformations.isEmpty
//                             ? ''
//                             : getVariantDescription(
//                                 item.cartVariantInformations)),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Text(
//                               Constant.currencyCode +
//                                   formatNumberWithThousandsSeparator(
//                                       item.totalPriceItem),
//                               style: AppTextStyles.productPrice,
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           //
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Text(
//                 'Subtotal ',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               Text(
//                   "(${dataConfirmCart!.cartInformation.totalMenu} Menu | ${dataConfirmCart!.cartInformation.totalItem} Item)",
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.normal,
//                       color: Warna.regulerFontColor)),
//               const Spacer(),
//               Text(
//                 Constant.currencyCode +
//                     formatNumberWithThousandsSeparator(
//                         dataConfirmCart!.cartInformation.subTotalPrice),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Warna.biru,
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget orderCalculateCostBox() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         // borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: Warna.abu,
//             width: 1.5,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           dataConfirmCart!.cartInformation.merchantInformation.merchantType ==
//                   "KANTIN"
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Biaya Pengiriman',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Warna.regulerFontColor,
//                       ),
//                     ),
//                     Text(
//                       "${Constant.currencyCode}${formatNumberWithThousandsSeparator(5000)}",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Warna.biru,
//                       ),
//                     )
//                   ],
//                 )
//               : Container(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Biaya Layanan',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               Text(
//                 "${Constant.currencyCode}${formatNumberWithThousandsSeparator(dataConfirmCart!.serviceCost)}",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                   color: Warna.biru,
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Text(
//                 'Total ',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 Constant.currencyCode +
//                     formatNumberWithThousandsSeparator(
//                         dataConfirmCart!.totalPrice),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Warna.biru,
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget boxOrderInfoDetail() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Catatan',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               Text(
//                 widget.noteOrder != '' ? widget.noteOrder : 'Tidak ada',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'No. Pesanan',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               const Spacer(),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     widget.orderNumber != '' ? widget.orderNumber : '768768976897678709',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   Text(
//                     'SALIN',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Warna.kuning,
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Waktu Pemesanan',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               Text(
//                 widget.orderTime != '' ? widget.orderTime : 'date mounth year, time',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Pembayaran',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               Text(
//                 widget.paymentMethod != '' ? widget.paymentMethod : 'cash',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// >>>>>>> 3f9f3e01d190d91a8882ff0e46bacfd79ab2f602
