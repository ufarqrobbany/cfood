import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:cfood/utils/routes.dart';
import 'package:flutter/services.dart';

// import 'package:'

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Mengatur gaya overlay sistem saat aplikasi diinisialisasi
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF002347), // Ganti dengan warna heksadesimal kustom Anda
      statusBarIconBrightness: Brightness.light, // Mengatur ikon status bar menjadi putih
    ));

     return MaterialApp(
      initialRoute: '/splash',
      onGenerateRoute: AppRoutes().generateRoute,
      debugShowCheckedModeBanner: false,
      title: 'C-FOOD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Warna.biru),
        useMaterial3: true,
      ),
    );
    
    // return MaterialApp.router(
    //   routerConfig: routes,
    //   debugShowCheckedModeBanner: false,
    //   title: 'C-FOOD',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   // home: const MyHomePage(title: 'HomePage'),
    // );
  }
  
  // HomeScreen() {}
}


