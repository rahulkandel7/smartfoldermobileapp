import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/item.dart';
import '../../data/repositories/item_repositories.dart';

class ItemController extends StateNotifier<AsyncValue<List<Item>>> {
  final int id;
  final ItemRepository _itemRepository;
  ItemController(this._itemRepository, this.id) : super(const AsyncLoading()) {
    fetchItems(id);
  }

  fetchItems(int id) async {
    final result = await _itemRepository.fetchItems(id);
    result.fold(
        (error) =>
            state = AsyncError(error, StackTrace.fromString(error.message)),
        (success) => state = AsyncData(success));
  }

  Future<List<String>> addItem(data) async {
    final result = await _itemRepository.addItem(data);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      fetchItems(id);
      return msg;
    });
  }

  Future<List<String>> deleteItem(int id) async {
    final result = await _itemRepository.deleteItem(id);
    return result.fold((error) {
      List<String> msg = ['false', error.message];
      return msg;
    }, (success) {
      List<String> msg = ['true', success];
      return msg;
    });
  }
}

final itemControllerProvider =
    StateNotifierProvider.family<ItemController, AsyncValue<List<Item>>, int>(
        (ref, id) {
  return ItemController(ref.watch(itemRepositoryProvider), id);
});
