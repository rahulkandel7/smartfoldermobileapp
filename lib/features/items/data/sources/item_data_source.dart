import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_service.dart';
import 'package:justsanppit/features/items/data/models/item.dart';

abstract class ItemDataSource {
  Future<List<Item>> fetchItem(int id);
  Future<String> addItem(var data);
  Future<String> deleteItem(int id);
}

final itemDataSourceProvider = Provider<ItemDataSource>((ref) {
  return ItemDataSourceImpl(ref.watch(apiServiceProvider));
});

class ItemDataSourceImpl extends ItemDataSource {
  final ApiService _apiService;

  ItemDataSourceImpl(this._apiService);

  @override
  Future<List<Item>> fetchItem(int id) async {
    final result = await _apiService.getDatawithAuthorize(endpoint: 'items/');
    final items = result as List<dynamic>;
    return items.map((item) => Item.fromMap(item)).toList();
  }

  @override
  Future<String> addItem(data) async {
    await _apiService.postDataWithAuthorize(endPoint: 'items/', data: data);
    return 'Item added successfully';
  }

  @override
  Future<String> deleteItem(int id) async {
    final result =
        await _apiService.deleteDataWithAuthorize(endpoint: 'items/$id/');
    return 'Item deleted successfully';
  }
}
