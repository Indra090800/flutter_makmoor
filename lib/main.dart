import 'dart:io';
import 'core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'presentation/auth/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/datasource/auth_local_datasource.dart';
import 'presentation/home/bloc/qris/qris_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'data/datasource/auth_remote_datasource.dart';
import 'presentation/home/pages/dashboard_page.dart';
import 'data/datasource/order_remote_datasource.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'data/datasource/product_local_datasource.dart';
import 'data/datasource/product_remote_datasource.dart';
import 'presentation/auth/bloc/logout/logout_bloc.dart';
import 'data/datasource/category_remote_datasource.dart';
import 'data/datasource/midtrans_remote_datasource.dart';
import 'data/datasource/discount_remote_datasource.dart';
import 'data/datasource/order_item_remote_datasource.dart';
import 'presentation/home/bloc/checkout/checkout_bloc.dart';
import 'presentation/report/blocs/summary/summary_bloc.dart';
import 'presentation/setting/bloc/discount/discount_bloc.dart';
import 'presentation/sales/blocs/day_sales/day_sales_bloc.dart';
import 'presentation/table/blocs/get_table/get_table_bloc.dart';
import 'presentation/sales/blocs/bloc/last_order_table_bloc.dart';
import 'presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'presentation/home/bloc/status_table/status_table_bloc.dart';
import 'presentation/home/bloc/order/order_bloc.dart' show OrderBloc;
import 'presentation/setting/bloc/add_product/add_product_bloc.dart';
import 'presentation/home/bloc/local_product/local_product_bloc.dart';
import 'presentation/setting/bloc/add_discount/add_discount_bloc.dart';
import 'presentation/setting/bloc/get_products/get_products_bloc.dart';
import 'presentation/setting/bloc/sync_product/sync_product_bloc.dart';
import 'presentation/home/bloc/online_checker/online_checker_bloc.dart';
import 'presentation/report/blocs/product_sales/product_sales_bloc.dart';
import 'presentation/table/blocs/generate_table/generate_table_bloc.dart';
import 'presentation/setting/bloc/get_categories/get_categories_bloc.dart';
import 'presentation/home/bloc/get_table_status/get_table_status_bloc.dart';
import 'presentation/report/blocs/item_sales_report/item_sales_report_bloc.dart';
import 'presentation/report/blocs/transaction_report/transaction_report_bloc.dart';



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
          create: (context) =>
              LocalProductBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DiscountBloc(DiscountRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => AddDiscountBloc(DiscountRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => TransactionReportBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GenerateTableBloc(),
        ),
        BlocProvider(
          create: (context) => GetTableBloc(),
        ),
        BlocProvider(
          create: (context) => StatusTableBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) =>
              LastOrderTableBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => GetTableStatusBloc(),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetProductsBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetCategoriesBloc(CategoryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SummaryBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductSalesBloc(OrderItemRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ItemSalesReportBloc(OrderItemRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DaySalesBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => QrisBloc(MidtransRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => OnlineCheckerBloc(),
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
                future: AuthLocalDataSource().isAuthDataExists(),
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
                      return const DashboardPage();
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
