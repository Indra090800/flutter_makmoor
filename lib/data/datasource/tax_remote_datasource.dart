import 'package:dartz/dartz.dart';
import 'auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/variable.dart';
import '../model/response/tax_discount_model.dart';


class TaxRemoteDatasource {
  Future<Either<String, TaxResponseModel>> getTaxs() async {
    final authData = await AuthLocalDataSource().getAuthData();
    final url = Uri.parse('${Variable.baseUrl}/api/api-taxes');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      return Right(TaxResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to get products');
    }
  }
}