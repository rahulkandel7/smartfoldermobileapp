import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_service.dart';
import 'package:justsanppit/features/assets/data/models/asset.dart';

abstract class AssetDataSource {
  Future<List<Asset>> fetchAsset();
  Future<String> addAsset(var data);
  Future<String> deleteAsset(int id);
}

final assetDataSourceProvider = Provider<AssetDataSource>((ref) {
  return AssetDataSourceImpl(ref.watch(apiServiceProvider));
});

class AssetDataSourceImpl extends AssetDataSource {
  final ApiService _apiService;

  AssetDataSourceImpl(this._apiService);

  @override
  Future<List<Asset>> fetchAsset() async {
    final result = await _apiService.getDatawithAuthorize(endpoint: 'assets');
    final assets = result['data'] as List<dynamic>;
    return assets.map((asset) => Asset.fromMap(asset)).toList();
  }

  @override
  Future<String> addAsset(data) async {
    await _apiService.postDataWithAuthorize(endPoint: 'assets/', data: data);
    return 'Asset added Sucessfully';
  }

  @override
  Future<String> deleteAsset(int id) async {
    final result =
        await _apiService.deleteDataWithAuthorize(endpoint: 'assets/$id');
    return result['message'];
  }
}
