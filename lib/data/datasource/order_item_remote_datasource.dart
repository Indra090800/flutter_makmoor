import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/variable.dart';
import '../model/response/item_sales_response_model.dart';
import '../model/response/product_sales_response_model.dart';


class OrderItemRemoteDatasource {
  Future<Either<String, ItemSalesResponseModel>> getItemSalesByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final authData = await AuthLocalDataSource().getAuthData();
      final response = await http.get(
        Uri.parse(
            '${Variable.baseUrl}/api/order-item?start_date=$stratDate&end_date=$endDate'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      log("Response: ${response.statusCode}");
      log("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(ItemSalesResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }

  Future<Either<String, ProductSalesResponseModel>> getProductSalesByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final authData = await AuthLocalDataSource().getAuthData();
      final response = await http.get(
        Uri.parse(
            '${Variable.baseUrl}/api/order-sales?start_date=$stratDate&end_date=$endDate'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      log("Response: ${response.statusCode}");
      log("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(ProductSalesResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }
}
