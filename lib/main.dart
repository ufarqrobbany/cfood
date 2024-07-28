import 'dart:developer';

import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/cart.dart';
import 'package:cfood/screens/chat.dart';
import 'package:cfood/screens/create_password.dart';
import 'package:cfood/screens/favorite.dart';
import 'package:cfood/screens/forgot_password.dart';
import 'package:cfood/screens/home.dart';
import 'package:cfood/screens/inbox.dart';
import 'package:cfood/screens/kantin_pages/main.dart';
import 'package:cfood/screens/kantin_pages/order.dart';
import 'package:cfood/screens/kantin_pages/transaction.dart';
import 'package:cfood/screens/login.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/order.dart';
import 'package:cfood/screens/orderStatus.dart';
import 'package:cfood/screens/order_detail.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/screens/profile.dart';
import 'package:cfood/screens/reviews.dart';
import 'package:cfood/screens/seeAll.dart';
import 'package:cfood/screens/signup.dart';
import 'package:cfood/screens/signup_student.dart';
import 'package:cfood/screens/splash.dart';
import 'package:cfood/screens/startup.dart';
import 'package:cfood/screens/user_info.dart';
import 'package:cfood/screens/verification.dart';

import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:cfood/utils/routes.dart';

// import 'package:'

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log or handle the error details
    log('${details.exception}');
    log('${details.context}');
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Mengatur gaya overlay sistem saat aplikasi diinisialisasi
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Color(0xFF002347), // Ganti dengan warna heksadesimal kustom Anda
      statusBarIconBrightness:
          Brightness.light, // Mengatur ikon status bar menjadi putih
    ));

    debugPrint('on main main');
    return MaterialApp(
      initialRoute: '/splash',
     onGenerateInitialRoutes: (String initialRouteName) {
        debugPrint('Generating initial route: $initialRouteName');
        List<Route<dynamic>> initialRoutes;
        if (initialRouteName == '/splash') {
          initialRoutes = [MaterialPageRoute(builder: (context) => const SplashScreen())];
        } else if (initialRouteName == '/home') {
          initialRoutes = [MaterialPageRoute(builder: (context) => const HomeScreen())];
        } else {
          initialRoutes = [MaterialPageRoute(builder: (context) => const StartUpScreen())];
        }
        return initialRoutes;
      },
     onGenerateRoute: (settings) {
        debugPrint('Navigating to ${settings.name}');
        switch (settings.name) {
          case '/splash':
            return _buildRoute(const SplashScreen(), settings);
          case '/startup':
            return _buildRoute(const StartUpScreen(), settings);
          case '/login':
            return _buildRoute(const LoginScreen(), settings);
          case '/register':
            return _buildRoute(const SignupScreen(), settings);
          case '/register-student':
            return _buildRoute(const SignUpStudentScreen(), settings);
          case '/verification':
            return _buildRoute(VerificationScreen(), settings);
          case '/verification-success':
            return _buildRoute(VerificationSuccess(), settings);
          case '/create-pass':
            return _buildRoute(CreatePasswordScreen(), settings);
          case '/forgot-pass':
            return _buildRoute(const ForgotPasswordScreen(), settings);
          case '/':
            return _buildRoute(const MainScreen(), settings);
          case '/home':
            return _buildRoute(const HomeScreen(), settings);
          case '/cart':
            return _buildRoute(const CartScreen(), settings);
          case '/order':
            return _buildRoute(const OrderScreen(), settings);
          case '/order-detail':
            return _buildRoute(const OrderDetailScreen(), settings);
          case '/order-status':
            return _buildRoute(const OrderStatusScreen(), settings);
          case '/inbox':
            return _buildRoute(InboxScreen(), settings);
          case '/chat':
            return _buildRoute(const ChatScreen(), settings);
          case '/organization':
            return _buildRoute(const OrganizationScreen(), settings);
          case '/see-all':
            return _buildRoute(const SeeAllItemsScreen(), settings);
          case '/profile':
            return _buildRoute(ProfileScreen(), settings);
          case '/user-info':
            return _buildRoute(const UserInformationScreen(), settings);
          case '/favorite':
            return _buildRoute(const FavoriteScreen(), settings);
          case '/canteen':
            return _buildRoute(const CanteenScreen(), settings);
          case '/review':
            return _buildRoute(const ReviewScreen(), settings);
          case '/main-canteen':
            return _buildRoute(const MainScreenCanteen(), settings);
          case '/order-canteen':
            return _buildRoute(const OrderCanteenScreen(), settings);
          case '/transaction':
            return _buildRoute(const TransactionScreen(), settings);
          default:
            return _buildRoute(const SplashScreen(), settings);
        }
      },
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
    //     colorScheme: ColorScheme.fromSeed(seedColor: Warna.biru),
    //     useMaterial3: true,
    //   ),
    //   // home: const MyHomePage(title: 'HomePage'),
    // );
  }

  //  routes: {
  //       '/splash': (context) => const SplashScreen(),
  //       '/startup': (context) => const StartUpScreen(),
  //       '/login': (context) => const LoginScreen(),
  //       '/register': (context) => const SignupScreen(),
  //       '/register-student': (context) => const SignUpStudentScreen(),
  //       '/verification': (context) => VerificationScreen(),
  //       '/verification-success': (context) => VerificationSuccess(),
  //       '/create-pass': (context) => CreatePasswordScreen(),
  //       '/forgot-pass': (context) => const ForgotPasswordScreen(),
  //       '/': (context) => const MainScreen(),
  //       '/home': (context) => const HomeScreen(),
  //       '/cart': (context) => const CartScreen(),
  //       '/order': (context) => const OrderScreen(),
  //       '/order-detail': (context) => const OrderDetailScreen(),
  //       '/order-status': (context) => const OrderStatusScreen(),
  //       '/inbox': (context) => InboxScreen(),
  //       '/chat': (context) => const ChatScreen(),
  //       '/organization': (context) => const OrganizationScreen(),
  //       '/see-all': (context) => const SeeAllItemsScreen(),
  //       '/profile': (context) => ProfileScreen(),
  //       '/user-info': (context) => const UserInformationScreen(),
  //       '/favorite': (context) => const FavoriteScreen(),
  //       '/canteen': (context) => const CanteenScreen(),
  //       '/review': (context) => const ReviewScreen(),
  //       '/main-canteen': (context) => const MainScreenCanteen(),
  //       '/order-canteen': (context) => const OrderCanteenScreen(),
  //       '/transaction': (context) => const TransactionScreen(),
  //     },

   


  MaterialPageRoute _buildRoute(Widget child, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => child,);
  }

  // HomeScreen() {}
}
