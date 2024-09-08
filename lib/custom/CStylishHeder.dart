import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class CStylishHeader extends StatelessWidget {
  final String title;
  final String description;
  const CStylishHeader({super.key, this.title = '', this.description = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              padding: const EdgeInsets.only(top: 50),
              width: 120,
              height: 160,
              alignment: Alignment.center,
              color: Warna.biru,
              child: Container(
                  // padding: const EdgeInsets.only(bottom: 20),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: 70,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(19),
                        topRight: Radius.circular(19),
                      )),
                  child: Image.asset(
                    'assets/logo.png',
                  )),
            ),
          ),
          Expanded(
            child: Container(
              height: 160,
              color: Warna.biru,
              padding: const EdgeInsets.fromLTRB(0, 64, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleBackgroundDark,
                  ),
                  Text(
                    description,
                    style: AppTextStyles.textRegularBackgroundDark,
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

class CustomClipPath extends CustomClipper<Path> {
  final radius = 10.0;
  final arcHeight = 50.0;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.arcToPoint(Offset(size.width, size.height - arcHeight),
        radius: Radius.circular(radius));
    path.lineTo(size.width, size.height - arcHeight / 2);
    path.lineTo(0, size.height - arcHeight / 2);
    path.lineTo(0, size.height - arcHeight);
    path.arcToPoint(Offset(0, size.height), radius: Radius.circular(radius));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
