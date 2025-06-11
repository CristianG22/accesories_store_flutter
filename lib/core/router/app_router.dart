import 'package:accesories_store_flutter/presentation/screens/catalog_screen.dart';
import 'package:accesories_store_flutter/presentation/screens/login_screen.dart';
import 'package:accesories_store_flutter/presentation/screens/main_screen.dart';
import 'package:accesories_store_flutter/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/test_screen.dart';
import '../../presentation/screens/checkout_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/cart_screen.dart';
import '../../presentation/screens/product_detail_screen.dart';
import 'package:accesories_store_flutter/presentation/screens/category_products_screen.dart';
import 'package:accesories_store_flutter/presentation/screens/test_drawer.dart';

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
    GoRoute(path: '/test', builder: (context, state) => const TestScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesList(),
    ),
    GoRoute(
      path: '/categoria/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return CategoryProductsScreen(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
  ],
);
