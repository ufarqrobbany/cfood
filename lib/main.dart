import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cfood/custom/CPageMover.dart';
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
// import 'package:cfood/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

// import 'package:'

void main() async {
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   // Log or handle the error details
  //   log('${details.exception}');
  //   log('${details.context}');
  // };
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  @override
  void initState() {
    // Mengatur gaya overlay sistem saat aplikasi diinisialisasi
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Color(0xFF002347), // Ganti dengan warna heksadesimal kustom Anda
      statusBarIconBrightness:
          Brightness.light, // Mengatur ikon status bar menjadi putih
    ));
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrint('on main main');
    return MaterialApp(
      initialRoute: '/splash',
      navigatorObservers: [RouteLogger()], 
      onGenerateInitialRoutes: (String initialRouteName) {
        debugPrint('Generating initial route: $initialRouteName');
        List<Route<dynamic>> initialRoutes;
        if (initialRouteName == '/splash') {
          initialRoutes = [
            MaterialPageRoute(builder: (context) => const SplashScreen())
          ];
        } else if (initialRouteName == '/home') {
          initialRoutes = [
            MaterialPageRoute(builder: (context) => const HomeScreen())
          ];
        } else {
          initialRoutes = [
            MaterialPageRoute(builder: (context) => const StartUpScreen())
          ];
        }
        return initialRoutes;
      },
      onGenerateRoute: (settings) {
        debugPrint('Navigating to ${settings.name}');
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(settings: settings, builder: (context) => const SplashScreen(), );
          case '/startup':
            return MaterialPageRoute(settings: settings, builder: (context) => const StartUpScreen(), );
          case '/login':
            return MaterialPageRoute(settings: settings, builder: (context) => const LoginScreen(),);
          case '/register':
            return MaterialPageRoute(settings: settings, builder: (context) => const SignupScreen(),);
          case '/register-student':
            return MaterialPageRoute(settings: settings, builder: (context) => const SignUpStudentScreen(),);
          case '/verification':
            return MaterialPageRoute(settings: settings, builder: (context) => VerificationScreen(),);
          case '/verification-success':
            return MaterialPageRoute(settings: settings, builder: (context) => VerificationSuccess(),);
          case '/create-pass':
            return MaterialPageRoute(settings: settings, builder: (context) => CreatePasswordScreen(),);
          case '/forgot-pass':
            return MaterialPageRoute(settings: settings, builder: (context) => const ForgotPasswordScreen(),);
          case '/':
            return MaterialPageRoute(settings: settings, builder: (context) => const MainScreen(),);
          case '/home':
            return MaterialPageRoute(settings: settings, builder: (context) => const HomeScreen(),);
          case '/cart':
            return MaterialPageRoute(settings: settings, builder: (context) => const CartScreen(),);
          case '/order':
            return MaterialPageRoute(settings: settings, builder: (context) => const OrderScreen(),);
          case '/order-detail':
            return MaterialPageRoute(settings: settings, builder: (context) => const OrderDetailScreen(),);
          case '/order-status':
            return MaterialPageRoute(settings: settings, builder: (context) => const OrderStatusScreen(),);
          case '/inbox':
            return MaterialPageRoute(settings: settings, builder: (context) => InboxScreen(),);
          case '/chat':
            return MaterialPageRoute(settings: settings, builder: (context) => ChatScreen(),);
          case '/organization':
            return MaterialPageRoute(settings: settings, builder: (context) => const OrganizationScreen(),);
          case '/see-all':
            return MaterialPageRoute(settings: settings, builder: (context) => const SeeAllItemsScreen(),);
          case '/profile':
            return MaterialPageRoute(settings: settings, builder: (context) => ProfileScreen(),);
          case '/user-info':
            return MaterialPageRoute(settings: settings, builder: (context) => const UserInformationScreen(),);
          case '/favorite':
            return MaterialPageRoute(settings: settings, builder: (context) => const FavoriteScreen(),);
          case '/canteen':
            return MaterialPageRoute(settings: settings, builder: (context) => const CanteenScreen(),);
          case '/review':
            return MaterialPageRoute(settings: settings, builder: (context) => const ReviewScreen(),);
          case '/main-canteen':
            return MaterialPageRoute(settings: settings, builder: (context) => const MainScreenCanteen(),);
          case '/order-canteen':
            return MaterialPageRoute(settings: settings, builder: (context) => const OrderCanteenScreen(),);
          case '/transaction':
            return MaterialPageRoute(settings: settings, builder: (context) => const TransactionScreen(),);
          default:
            return MaterialPageRoute(settings: settings, builder: (context) => const SplashScreen(),);
        }
      },
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/startup': (context) => const StartUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(),
        '/register-student': (context) => const SignUpStudentScreen(),
        '/verification': (context) => VerificationScreen(),
        '/verification-success': (context) => VerificationSuccess(),
        '/create-pass': (context) => CreatePasswordScreen(),
        '/forgot-pass': (context) => const ForgotPasswordScreen(),
        '/': (context) => const MainScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/order': (context) => const OrderScreen(),
        '/order-detail': (context) => const OrderDetailScreen(),
        '/order-status': (context) => const OrderStatusScreen(),
        '/inbox': (context) => InboxScreen(),
        '/chat': (context) => ChatScreen(),
        '/organization': (context) => const OrganizationScreen(),
        '/see-all': (context) => const SeeAllItemsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/user-info': (context) => const UserInformationScreen(),
        '/favorite': (context) => const FavoriteScreen(),
        '/canteen': (context) => const CanteenScreen(),
        '/review': (context) => const ReviewScreen(),
        '/main-canteen': (context) => const MainScreenCanteen(),
        '/order-canteen': (context) => const OrderCanteenScreen(),
        '/transaction': (context) => const TransactionScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'C-FOOD',
      theme: ThemeData(
        fontFamily: 'Lato',
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

  MaterialPageRoute _buildRoute(Widget child, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => child,
    );
  }
}
