import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/api_constants.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/core/utils/toast.dart';
import 'package:justsanppit/features/assets/presentation/controllers/asset_controller.dart';

import '../../../assets/data/models/asset.dart';
import '../controllers/item_controller.dart';
import 'widgets/add_item.dart';

class ItemScreen extends ConsumerWidget {
  const ItemScreen({super.key});

  InkWell listItems(
      {required Size size,
      required String photopath,
      required int id,
      required WidgetRef ref,
      required BuildContext context}) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(AppRoutes.imageView, arguments: photopath),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(itemControllerProvider(id).notifier)
                      .deleteItem(id)
                      .then((value) {
                    if (value[0] == 'true') {
                      toast(
                          context: context,
                          label: value[1],
                          color: Colors.green);
                      ref.invalidate(itemControllerProvider);
                    } else {
                      toast(
                          context: context, label: value[1], color: Colors.red);
                    }
                    Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.grey.shade800),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: size.width * 0.43,
        height: size.height * 0.2,
        margin: EdgeInsets.all(size.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.network(
          '${ApiConstants.imageUrl}$photopath',
          height: size.height * 0.14,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    int id = ModalRoute.of(context)!.settings.arguments as int;
    Asset asset = ref.read(assetControllerProvider.notifier).findById(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          asset.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: AddItem(
        size: size,
        id: id,
      ),
      body: ref.watch(itemControllerProvider(id)).when(
            data: (items) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.grey.shade900,
                                textStyle: TextStyle(
                                  fontSize: size.width * 0.06,
                                ),
                                fixedSize:
                                    Size(size.width * 0.7, size.height * 0.03),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Add Notes',
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          children: [
                            for (int i = 0; i < items.length; i++)
                              listItems(
                                size: size,
                                photopath: items[i].photopath,
                                context: context,
                                ref: ref,
                                id: items[i].id,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (e, s) => Center(
              child: Text(e.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
