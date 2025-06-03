import 'package:accesories_store/presentation/screens/catalog_screen.dart';
import 'package:accesories_store/presentation/screens/login_screen.dart';
import 'package:accesories_store/presentation/screens/main_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/test_screen.dart';
import '../../presentation/screens/checkout_screen.dart';
import '../../presentation/screens/profile_screen.dart';


final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/test',
      builder: (context, state) => const TestScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesList(),
    ),
  ],
);

