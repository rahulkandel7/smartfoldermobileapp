import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_error.dart';
import 'package:justsanppit/core/api/dio_exception.dart';
import 'package:justsanppit/features/assets/data/models/asset.dart';
import 'package:justsanppit/features/assets/data/sources/asset_data_source.dart';

abstract class AssetRepository {
  Future<Either<ApiError, List<Asset>>> fetchAsset();
  Future<Either<ApiError, String>> addAsset(var data);
  Future<Either<ApiError, String>> deleteAsset(int id);
}

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return AssetRepositoryImpl(ref.watch(assetDataSourceProvider));
});

class AssetRepositoryImpl extends AssetRepository {
  final AssetDataSource _assetDataSource;

  AssetRepositoryImpl(this._assetDataSource);

  @override
  Future<Either<ApiError, List<Asset>>> fetchAsset() async {
    try {
      final result = await _assetDataSource.fetchAsset();
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> addAsset(data) async {
    try {
      final result = await _assetDataSource.addAsset(data);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> deleteAsset(int id) async {
    try {
      final result = await _assetDataSource.deleteAsset(id);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }
}
