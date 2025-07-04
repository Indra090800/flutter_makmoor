import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/variable.dart';
import '../model/response/summary_response_model.dart';
import '../model/response/order_remote_datasource.dart';
import '../../presentation/home/models/order_model.dart';

class OrderRemoteDatasource {
  Future<bool> saveOrder(OrderModel orderModel) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final url = Uri.parse('${Variable.baseUrl}/api/save-order');

    final response = await http.post(url, body: orderModel.toJson(), headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Either<String, OrderResponseModel>> getOrderByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final authData = await AuthLocalDataSource().getAuthData();
      final response = await http.get(
        Uri.parse(
            '${Variable.baseUrl}/api/orders?start_date=$stratDate&end_date=$endDate'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      log("Response: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(OrderResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }

  Future<Either<String, SummaryResponseModel>> getSummaryByRangeDate(
    String stratDate,
    String endDate,
  ) async {
    try {
      final authData = await AuthLocalDataSource().getAuthData();
      final response = await http.get(
        Uri.parse(
            '${Variable.baseUrl}/api/summary?start_date=$stratDate&end_date=$endDate'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      log("Url: ${response.request!.url}");
      log("Response: ${response.statusCode}");

      log("Response: ${response.body}");
      if (response.statusCode == 200) {
        return Right(SummaryResponseModel.fromJson(response.body));
      } else {
        return const Left("Failed Load Data");
      }
    } catch (e) {
      log("Error: $e");
      return Left("Failed: $e");
    }
  }
}
