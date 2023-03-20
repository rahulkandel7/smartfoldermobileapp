import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/features/assets/data/models/asset.dart';
import 'package:justsanppit/features/assets/data/repositories/asset_repositories.dart';

class AssetController extends StateNotifier<AsyncValue<List<Asset>>> {
  final AssetRepository _assetRepository;
  AssetController(this._assetRepository) : super(const AsyncLoading()) {
    fetchAsset();
  }

  fetchAsset() async {
    final result = await _assetRepository.fetchAsset();
    result.fold(
        (error) =>
            state = AsyncError(error, StackTrace.fromString(error.message)),
        (success) => state = AsyncData(success));
  }

  Future<List<String>> addAsset(data) async {
    final result = await _assetRepository.addAsset(data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }

  Future<List<String>> deleteAsset(int id) async {
    final result = await _assetRepository.deleteAsset(id);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }
}

final assetControllerProvider =
    StateNotifierProvider<AssetController, AsyncValue<List<Asset>>>((ref) {
  return AssetController(ref.watch(assetRepositoryProvider));
});
