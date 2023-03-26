import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justsanppit/constants/app_routes.dart';
import 'package:justsanppit/core/utils/toast.dart';
import 'package:justsanppit/features/assets/presentation/controllers/asset_controller.dart';
import 'package:justsanppit/features/items/data/models/item.dart';

import '../../../../core/utils/form_field.dart';
import '../../../assets/data/models/asset.dart';
import '../controllers/item_controller.dart';
import '../controllers/note_controller.dart';
import 'widgets/add_item.dart';
import 'widgets/show_note_item.dart';

class ItemScreen extends ConsumerStatefulWidget {
  const ItemScreen({super.key});

  @override
  ItemScreenState createState() => ItemScreenState();
}

class ItemScreenState extends ConsumerState<ItemScreen> {
  final _addNoteKey = GlobalKey<FormState>();

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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            photopath,
            height: size.height * 0.14,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  late String title;

  late String description;

  Future<dynamic> addNote({
    required BuildContext context,
    required Size size,
    required int assetId,
  }) {
    return showDialog(
      builder: (context) {
        return Dialog(
          child: Container(
            width: size.width * 0.7,
            height: size.height * 0.41,
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03,
              vertical: size.height * 0.01,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade800,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Add Note',
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    color: Colors.grey.shade300,
                  ),
                ),
                Form(
                  key: _addNoteKey,
                  child: Column(
                    children: [
                      formField(
                        label: 'Enter Title',
                        iconData: Icons.abc,
                        size: size,
                        handleSave: (value) {
                          title = value!;
                        },
                        textInputType: TextInputType.text,
                        handleValidate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide Title';
                          } else {
                            return null;
                          }
                        },
                      ),
                      formField(
                        label: 'Enter Description',
                        iconData: Icons.text_fields_outlined,
                        size: size,
                        textInputType: TextInputType.multiline,
                        maxLines: 2,
                        handleSave: (value) {
                          description = value!;
                        },
                        handleValidate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide Description';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                // * Added Asset Button
                Consumer(
                  builder: (context, ref, child) {
                    return FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.grey.shade900,
                      ),
                      onPressed: () async {
                        if (!_addNoteKey.currentState!.validate()) {
                          return;
                        }
                        _addNoteKey.currentState!.save();

                        Map<String, dynamic> data = {
                          'title': title,
                          'description': description,
                          'asset_id': assetId,
                        };

                        ref
                            .read(noteControllerProvider(assetId).notifier)
                            .addNote(data)
                            .then((value) {
                          if (value[0] == 'false') {
                            toast(
                                context: context,
                                label: value[1],
                                color: Colors.red);
                          } else {
                            toast(
                                context: context,
                                label: value[1],
                                color: Colors.green);
                            ref.invalidate(noteControllerProvider);
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      icon: const Icon(Icons.save_alt_outlined),
                      label: const Text(
                        'Save Note',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            data: (data) {
              List<Item> items =
                  data.where((item) => item.assetId == asset.id).toList();
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
                              onPressed: () => addNote(
                                  context: context, size: size, assetId: id),
                              child: const Text(
                                'Add Notes',
                              ),
                            ),
                          ),
                        ),
                        ref.watch(noteControllerProvider(asset.id)).when(
                              data: (notes) {
                                return Column(
                                  children: notes
                                      .map(
                                        (note) => ShowNoteItem(
                                          note: note,
                                          assetId: id,
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                              error: (e, s) {
                                return Text(e.toString());
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
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
