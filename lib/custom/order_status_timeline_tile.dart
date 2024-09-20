import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

// final orderStatusProses = [
//   'Dikonfirmasi',
//   'Diproses',
//   'Diantar',
//   'Selesai',
// ];

// final List<Map<String, dynamic>> orderStatusProses = [
//   {
//     'status': '',
//     'time': '00.00',
//     'done': false,
//     'onProgress': false,
//   },
//   {
//     'status': 'Dikonfirmasi',
//     'time': '00.00',
//     'done': false,
//     'onProgress': false,
//   },
//   {
//     'status': 'Diantar',
//     'time': '00.00',
//     'done': false,
//     'onProgress': false,
//   },
//   {
//     'status': 'Selesai',
//     'time': '00.00',
//     'done': false,
//     'onProgress': false,
//   },
// ];

class StatusOrderTimeLineTileWidget extends StatefulWidget {
  final String? status;
  final int processIndex;
  final List<Map<String, dynamic>>? statusListMapData;
  const StatusOrderTimeLineTileWidget({
    super.key,
    this.status,
    this.processIndex = 0,
    this.statusListMapData,
  });

  @override
  State<StatusOrderTimeLineTileWidget> createState() =>
      _StatusOrderTimeLineTileWidgetState();
}

class _StatusOrderTimeLineTileWidgetState
    extends State<StatusOrderTimeLineTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        connectorTheme: const ConnectorThemeData(
          space: 30.0,
          thickness: 5.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
          itemCount: widget.statusListMapData!.length,
          connectionDirection: ConnectionDirection.after,
          itemExtent: 90,
          // itemExtent: MediaQuery.of(context).size.width / widget.statusListMapData!.length,
          oppositeContentsBuilder: (context, index) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.statusListMapData![index]['time'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Warna.abu3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
          contentsBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.statusListMapData![index]['status'].toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
          indicatorBuilder: (context, index) {
            bool isDone = widget.statusListMapData![index]['done'] == true;
            bool isProgress =
                widget.statusListMapData![index]['onProgress'] == true;
            return Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isDone
                      ? Warna.hijau
                      : isProgress
                          ? Warna.oranye1
                          : Warna.abu3,
                  width: 2,
                ),
              ),
              child: Image.asset(
                'assets/order_timeline_status_image/${index + 1}.png',
                fit: BoxFit.cover,
              ),
            );
          },
          connectorBuilder: (_, index, type) {
            bool isDone = widget.statusListMapData![index]['done'] == true;
            bool isProgress =
                widget.statusListMapData![index]['onProgress'] == true;
            return DecoratedLineConnector(
              decoration: BoxDecoration(
                color: isDone
                    ? Warna.hijau
                    : isProgress
                        ? Warna.oranye1
                        : Warna.abu3,
              ),
            );
            // return Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 3),
            //   child: SolidLineConnector(indent: 0,
            //     color: isDone ? Warna.hijau : isProgress ? Warna.oranye1 : Warna.abu3,
            //   ),
            // );
          }),
    );
  }
}
