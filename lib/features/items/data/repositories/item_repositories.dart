import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/core/api/api_error.dart';
import 'package:justsanppit/core/api/dio_exception.dart';
import 'package:justsanppit/features/items/data/models/item.dart';
import 'package:justsanppit/features/items/data/sources/item_data_source.dart';

abstract class ItemRepository {
  Future<Either<ApiError, List<Item>>> fetchItems(int id);
  Future<Either<ApiError, String>> addItem(var data);
  Future<Either<ApiError, String>> deleteItem(int id);
}

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepositoryImpl(ref.watch(itemDataSourceProvider));
});

class ItemRepositoryImpl extends ItemRepository {
  final ItemDataSource _itemDataSource;

  ItemRepositoryImpl(this._itemDataSource);

  @override
  Future<Either<ApiError, List<Item>>> fetchItems(int id) async {
    try {
      final result = await _itemDataSource.fetchItem(id);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> addItem(data) async {
    try {
      final result = await _itemDataSource.addItem(data);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }

  @override
  Future<Either<ApiError, String>> deleteItem(int id) async {
    try {
      final result = await _itemDataSource.deleteItem(id);
      return right(result);
    } on DioException catch (e) {
      return left(ApiError(message: e.message!));
    }
  }
}
