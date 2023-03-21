import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/api_constants.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/core/utils/add_item.dart';
import 'package:justsanppit/core/utils/toast.dart';
import 'package:justsanppit/features/assets/presentation/controllers/asset_controller.dart';

class AssetScreen extends ConsumerWidget {
  const AssetScreen({super.key});

  InkWell listAssets(
      {required Size size,
      required String name,
      required String photopath,
      required int id,
      required WidgetRef ref,
      required BuildContext context}) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRoutes.itemScreen, arguments: id),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(assetControllerProvider.notifier)
                      .deleteAsset(id)
                      .then((value) {
                    if (value[0] == 'true') {
                      toast(
                          context: context,
                          label: value[1],
                          color: Colors.green);
                      ref.invalidate(assetControllerProvider);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
              '${ApiConstants.imageUrl}$photopath',
              height: size.height * 0.14,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: AutoSizeText(
                maxLines: 1,
                name,
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  color: Colors.grey.shade300,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ref.watch(assetControllerProvider).when(
            data: (assets) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.03,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02),
                          child: Center(
                            child: SizedBox(
                              height: size.height * 0.2,
                              width: size.width * 0.5,
                              child: Image.asset('assets/logo/logo.png'),
                            ),
                          ),
                        ),
                        Wrap(
                          children: [
                            for (int i = 0; i < assets.length; i++)
                              listAssets(
                                size: size,
                                name: assets[i].name,
                                photopath: assets[i].photopath,
                                context: context,
                                ref: ref,
                                id: assets[i].id,
                              ),
                            //* Add Item Button
                            AddItem(size: size),
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
