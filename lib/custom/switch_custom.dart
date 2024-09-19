import 'package:flutter/material.dart';

class SwitchWithBorder extends StatefulWidget {
  final bool initialAccept;
  final ValueChanged<bool> onChanged;

  const SwitchWithBorder({
    super.key,
    required this.initialAccept,
    required this.onChanged,
  });

  @override
  _SwitchWithBorderState createState() => _SwitchWithBorderState();
}

class _SwitchWithBorderState extends State<SwitchWithBorder> {
  late bool accept;

  @override
  void initState() {
    super.initState();
    accept = widget.initialAccept;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          accept = !accept;
        });
        widget.onChanged(accept);
      },
      child: Container(
        padding: const EdgeInsets.all(4.0), // Padding between toggle circle and border
        decoration: BoxDecoration(
          border: Border.all(
            color: accept ? Colors.green : Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 50.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: accept ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            Align(
              alignment: accept ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26.0,
                height: 26.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
