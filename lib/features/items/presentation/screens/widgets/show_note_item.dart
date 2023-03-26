import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/form_field.dart';
import '../../../../../core/utils/toast.dart';
import '../../../data/models/note.dart';
import '../../controllers/note_controller.dart';

class ShowNoteItem extends ConsumerStatefulWidget {
  const ShowNoteItem({
    super.key,
    required this.note,
    required this.assetId,
  });

  final Note note;
  final int assetId;

  @override
  ShowNoteItemState createState() => ShowNoteItemState();
}

class ShowNoteItemState extends ConsumerState<ShowNoteItem> {
  final _updateNoteKey = GlobalKey<FormState>();

  late String title;
  late String description;

  Future<dynamic> updateNote({
    required BuildContext context,
    required Size size,
    required int assetId,
    required Note note,
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
                  'Update Note',
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    color: Colors.grey.shade300,
                  ),
                ),
                Form(
                  key: _updateNoteKey,
                  child: Column(
                    children: [
                      formField(
                        initialValue: note.title,
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
                        initialValue: note.description,
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
                // * Update note Button
                Consumer(
                  builder: (context, ref, child) {
                    return FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.grey.shade900,
                      ),
                      onPressed: () async {
                        if (!_updateNoteKey.currentState!.validate()) {
                          return;
                        }
                        _updateNoteKey.currentState!.save();

                        Map<String, dynamic> data = {
                          'title': title,
                          'description': description,
                          'asset_id': assetId,
                        };

                        ref
                            .read(noteControllerProvider(assetId).notifier)
                            .updateNote(note.id, data)
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
                        'Update Note',
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
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(noteControllerProvider(widget.assetId).notifier)
                      .deleteNote(widget.note.id)
                      .then((value) {
                    if (value[0] == 'true') {
                      toast(
                          context: context,
                          label: value[1],
                          color: Colors.green);
                      ref.invalidate(noteControllerProvider);
                    } else {
                      toast(
                          context: context, label: value[1], color: Colors.red);
                      ref.invalidate(noteControllerProvider);
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
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            vertical: size.height * 0.01, horizontal: size.width * 0.01),
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.01, horizontal: size.width * 0.01),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(
              widget.note.title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.grey.shade200,
                  ),
            ),
            Text(
              widget.note.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey.shade800,
                textStyle: TextStyle(
                  fontSize: size.width * 0.05,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                fixedSize: Size(size.width * 0.7, size.height * 0.03),
              ),
              onPressed: () => updateNote(
                  context: context,
                  size: size,
                  assetId: widget.assetId,
                  note: widget.note),
              child: const Text(
                'Update Note',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
