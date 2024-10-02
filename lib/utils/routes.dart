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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// class AppRoutes {
  final GoRouter routes = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: 'splash',
        path: '/splash',
        // builder: (context, state) => const SplashScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SplashScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'startup',
        path: '/startup',
        // builder: (context, state) => const StartUpScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const StartUpScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'login',
        path: '/login',
        // builder: (context, state) => const LoginScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const LoginScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'register',
        path: '/register',
        // builder: (context, state) => const SignupScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SignupScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'register-students',
        path: '/register-student',
        // builder: (context, state) => const SignUpStudentScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SignUpStudentScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'verification',
        path: '/verification',
        // builder: (context, state) =>  VerificationScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child:  VerificationScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'verification-success',
        path: '/verification-success',
        // builder: (context, state) =>  VerificationScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child:  VerificationSuccess(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'create-pass',
        path: '/create-pass',
        // builder: (context, state) => CreatePasswordScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: CreatePasswordScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'forgot-pass',
        path: '/forgot-pass',
        // builder: (context, state) => const ForgotPasswordScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const ForgotPasswordScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'main',
        path: '/',
        // builder: (context, state) => const MainScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: MainScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'home',
        path: '/home',
        // builder: (context, state) => const HomeScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const HomeScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'cart',
        path: '/cart',
        // builder: (context, state) => const CartScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const CartScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'order',
        path: '/order',
        // builder: (context, state) => const OrderScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const OrderScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'order-detail',
        path: '/order-detail',
        // builder: (context, state) => const OrderScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const OrderScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'order-status',
        path: '/order-status',
        // builder: (context, state) => const OrderScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const OrderStatusScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'inbox',
        path: '/inbox',
        // builder: (context, state) => InboxScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: InboxScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut,).animate(animation),
                child: child,
              );
            },);
        },
      ),
      GoRoute(
        name: 'chat',
        path: '/chat',
        // builder: (context, state) => const ChatScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: ChatScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'organization',
        path: '/organization',
        // builder: (context, state) => const ChatScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const OrganizationScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'see-all',
        path: '/seall',
        // builder: (context, state) => const ChatScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SeeAllItemsScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'profile',
        path: '/profile',
        // builder: (context, state) => const ProfileScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: ProfileScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'user-info',
        path: '/user-info',
        // builder: (context, state) => const OrderScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const UserInformationScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'favorite',
        path: '/favorite',
        // builder: (context, state) => const FavoriteScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const FavoriteScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      
      GoRoute(
        name: 'canteen',
        path: '/canteen',
        // builder: (context, state) => const OrderScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const CanteenScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'review',
        path: '/review',
        // builder: (context, state) => const OrderScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const ReviewScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'main-canteen',
        path: '/main-canteen',
        // builder: (context, state) => const FavoriteScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const MainScreenCanteen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'order-canteen',
        path: '/order-canteen',
        // builder: (context, state) => const FavoriteScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const OrderCanteenScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      GoRoute(
        name: 'transaction',
        path: '/transaction',
        // builder: (context, state) => const FavoriteScreen(),
         pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const TransactionScreen(), 
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

    ],
  );
// }


class AppRoutes{
  Route<dynamic>? generateRoute(RouteSettings settings) {
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
        return _buildRoute( MainScreen(), settings);
      case '/home':
        return _buildRoute(const HomeScreen(), settings);
      case '/cart':
        return _buildRoute(const CartScreen(), settings);
      case '/order':
        return _buildRoute(const OrderScreen(), settings);
      case '/order-detail':
        return _buildRoute(const OrderScreen(), settings);
      case '/order-status':
        return _buildRoute(const OrderStatusScreen(), settings);
      case '/inbox':
        return _buildRoute(InboxScreen(), settings);
      case '/chat':
        return _buildRoute( ChatScreen(), settings);
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
  }

  PageRouteBuilder _buildRoute(Widget child, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}