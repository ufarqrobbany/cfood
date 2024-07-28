import 'package:carousel_slider/carousel_slider.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/screens/login.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  final CarouselController sliderController = CarouselController();
  int sliderNumber = 0;

  final List<Map<String, dynamic>> startUpItems = [
    {
      'no': 1,
      'image': 'assets/startup_img_slider_1.png',
      'title': 'Dari C-Food Menuju Perut',
      'description': 'Gak Perlu Ribet ke kantin buat jajan, tinggal pesan aja lewat C-Food, langsung diantar ke posisi kamu. Praktis banget!'
    },
    {
      'no': 2,
      'image': 'assets/startup_img_slider_2.png',
      'title': 'Dapatkan Penghasilan',
      'description': 'Jadi penjual atau kurir di kampus lewat C-Food, gampang banget dapet cuan tambahan, ayo gabung!'
    },
  ];

  @override
  void initState(){
    super.initState();
  }

  void _nextPage() {
    setState(() {
      sliderNumber = (sliderNumber + 1) % startUpItems.length;
    });
    // sliderController.jumpToPage(sliderNumber);
     sliderController.animateToPage(
      sliderNumber,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ICON
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Image.asset(
                'assets/logo.png',
                height: 100,
              ),
            ),
          ),
          // CAROUSEL SLIDER
          Container(
            // height: MediaQuery.of(context).size.height * 0.60,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.60,
                autoPlay: false,
                animateToClosest: false,
                enableInfiniteScroll: false,
                padEnds: true,
                // pageSnapping: false,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: 0,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                setState(() {
                  sliderNumber = index;
                });
            },
              ),
              itemCount: startUpItems.length,
              carouselController: sliderController,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                return Column(
                  children: [
                    // IMAGE
                    Image.asset(
                      startUpItems[itemIndex]['image'],
                      height: MediaQuery.of(context).size.height * 0.35,
                      // height: 300,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // TEXT
                    Text(
                      startUpItems[itemIndex]['title'],
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Text(
                        startUpItems[itemIndex]['description'],
                        style: AppTextStyles.textRegular,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                );
              }, 
            ),
          ),
          // INDICATOR
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: sliderIndicator()),
          // BUTTON
          MaterialButton(
            height: 55,
            minWidth: MediaQuery.of(context).size.width * 0.88,
            color: Warna.biru,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            onPressed: () {
              if (sliderNumber == startUpItems.length - 1) {
                navigateToRep(context, const LoginScreen());
                // context.pushReplacementNamed('login');
              } else {
                // print(sliderNumber);
                _nextPage();
              }
              // sliderController.nextPage(
              //     duration: const Duration(milliseconds: 300),
              //     curve: Curves.linear);
              
            },
            child: Text(
              sliderNumber == 0 ? 'Lanjut' : 'Masuk',
              style: AppTextStyles.textButtonBackgroundDark,
            ),
          ),

        ],
      ),
    );
  }

  Widget sliderIndicator() => AnimatedSmoothIndicator(
        activeIndex: sliderNumber,
        count: startUpItems.length,
        effect: ScrollingDotsEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Warna.kuning,
          dotColor: Colors.grey,
        ),
      );
}