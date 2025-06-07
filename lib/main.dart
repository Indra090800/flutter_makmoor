import 'dart:io';
import 'core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'pages/auth/login/login_bloc.dart';
import 'pages/auth/pages/login_page.dart';
import 'pages/auth/logout/logout_bloc.dart';
import 'pages/home/bloc/order/order_bloc.dart';
import 'pages/settings/bloc/tax/tax_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home/pages/main_nav_desktop.dart';
import 'data/datasource/tax_remote_datasource.dart';
import 'data/datasource/auth_local_datasource.dart';
import 'pages/home/bloc/checkout/checkout_bloc.dart';
import 'data/datasource/auth_remote_datasource.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'data/datasource/order_remote_datasource.dart';
import 'data/datasource/product_local_datasource.dart';
import 'data/datasource/product_remote_datasource.dart';
import 'data/datasource/discount_remote_datasource.dart';
import 'pages/settings/bloc/discount/discount_bloc.dart';
import 'pages/settings/bloc/sync_order/sync_order_bloc.dart';
import 'pages/home/bloc/local_product/local_product_bloc.dart';
import 'pages/settings/bloc/add_discount/add_discount_bloc.dart';
import 'pages/settings/bloc/sync_product/sync_product_bloc.dart';



void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncProductBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LocalProductBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DiscountBloc(DiscountRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => TaxBloc(TaxRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => AddDiscountBloc(DiscountRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Makmoor',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.green,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.green,
            ),
          ),
        ),
        home: screenWidth < 600
            ? const Scaffold(
                body: Center(
                  child: Text(
                    'App Khusus Screen With 600 (Tablet Version) ganti resolusi anda.',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              )
            : FutureBuilder<bool>(
                future: AuthLocalDataSource().isAuthDataExist(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (asyncSnapshot.hasData) {
                    if (asyncSnapshot.data!) {
                      return const MainNavDesktop();
                    } else {
                      return const LoginPage();
                    }
                  }
                  return const Scaffold(
                    body: Center(
                      child: Text('Error'),
                    ),
                  );
                }),
      ),
    );
  }
}
