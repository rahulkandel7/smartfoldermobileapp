import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsanppit/core/utils/toast.dart';
import 'package:justsanppit/features/items/presentation/controllers/item_controller.dart';

class AddItem extends StatefulWidget {
  final Size size;
  final int id;
  final BuildContext ctx;
  const AddItem(
      {required this.size, required this.id, required this.ctx, super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  File? image;

  bool isProcessing = false;

  setIsProcessingTrue() {
    setState(() {
      isProcessing = true;
    });
    Navigator.of(context).pop();
    showItemAddDialog(context);
  }

  setIsProcessingFalse() {
    setState(() {
      isProcessing = false;
    });
    Navigator.of(context).pop();
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        showItemAddDialog(context);
      });
    } catch (e) {
      toast(
          context: context,
          label: 'Failed to choose the image',
          color: Colors.red);
    }
  }

  Future<dynamic> showChooseImageButton(BuildContext context, Size size) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: size.height * 0.14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey.shade800,
                  ),
                  onPressed: () => pickImage(ImageSource.camera),
                  child: const Text(
                    'Select from camera',
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey.shade800,
                  ),
                  onPressed: () => pickImage(ImageSource.gallery),
                  child: const Text(
                    'Choose from gallery',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.size.width * 0.07,
      child: IconButton(
        onPressed: () => showItemAddDialog(context),
        icon: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<dynamic> showItemAddDialog(BuildContext context) {
    return showDialog(
      builder: (context) {
        return Dialog(
          child: Container(
            width: widget.size.width * 0.7,
            height: widget.size.height * 0.3,
            padding: EdgeInsets.symmetric(
              horizontal: widget.size.width * 0.03,
              vertical: widget.size.height * 0.01,
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
                // * Show Image or choose image buttom
                Container(
                  width: widget.size.width * 0.6,
                  height: widget.size.height * 0.18,
                  margin:
                      EdgeInsets.symmetric(vertical: widget.size.height * 0.02),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: image == null
                      ? Center(
                          child: IconButton(
                            onPressed: () =>
                                showChooseImageButton(context, widget.size),
                            icon: Icon(
                              Icons.add_photo_alternate_outlined,
                              size: widget.size.width * 0.2,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () =>
                              showChooseImageButton(context, widget.size),
                          child: Image.file(
                            File(
                              image!.path,
                            ),
                          ),
                        ),
                ),
                // * Added Asset Button
                isProcessing
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 0.6,
                        ),
                      )
                    : Consumer(
                        builder: (context, ref, child) {
                          return FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              foregroundColor: Colors.grey.shade900,
                            ),
                            onPressed: () async {
                              if (image!.path.isEmpty) {
                                toast(
                                    context: context,
                                    label: 'Please Choose Image',
                                    color: Colors.red);
                                return;
                              }
                              setIsProcessingTrue();

                              FormData formData;

                              formData = FormData.fromMap({
                                'assest_id': widget.id,
                                'photo': await MultipartFile.fromFile(
                                    image!.absolute.path),
                              });

                              ref
                                  .read(itemControllerProvider(widget.id)
                                      .notifier)
                                  .addItem(formData)
                                  .then((value) {
                                if (value[0] == 'false') {
                                  toast(
                                      context: widget.ctx,
                                      label: value[1],
                                      color: Colors.red);
                                } else {
                                  toast(
                                      context: widget.ctx,
                                      label: value[1],
                                      color: Colors.green);
                                }
                                image = null;

                                setIsProcessingFalse();
                              });
                            },
                            icon: const Icon(Icons.save_alt_outlined),
                            label: const Text(
                              'Save Item',
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
}
