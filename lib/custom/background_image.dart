import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class BackgroundImageGenerated extends StatelessWidget {
//   const BackgroundImageGenerated({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MasonryGridView.count(
//       itemCount: 10,
//       crossAxisCount: 2,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) => Image.asset('assets/background_chat.png', width: MediaQuery.of(context).size.width * 0.50,),
//       );
//   }
// }

class BackgroundImageGenerated extends StatelessWidget {
  const BackgroundImageGenerated({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const itemHeight = 150.0; // Fixed item height
    final numberOfRows = (screenHeight / itemHeight).ceil(); // Determine number of rows
    final numberOfItems = numberOfRows * 2; // Total items to fill the grid (2 items per row)

    return MasonryGridView.count(
      itemCount: numberOfItems,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
        height: itemHeight,
        child: Opacity(
          opacity: 0.1,
          child: Image.asset(
            'assets/background_chat.png',
            width: MediaQuery.of(context).size.width / 2,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}