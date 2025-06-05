import 'package:dartz/dartz.dart';
import 'auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/variable.dart';
import '../model/response/product_response_model.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDataSource().getAuthData();
    final url = Uri.parse('${Variable.baseUrl}/api/api-products');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
    });
    print(response.body);

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to get products');
    }
  }
}
