import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsanppit/core/utils/toast.dart';
import 'package:justsanppit/features/assets/presentation/controllers/asset_controller.dart';

import 'form_field.dart';

class AddItem extends StatefulWidget {
  final Size size;
  const AddItem({required this.size, super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  File? image;
  String name = '';

  bool isProcessing = false;

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
    return InkWell(
      onTap: () => showItemAddDialog(context),
      child: Container(
        width: widget.size.width * 0.43,
        height: widget.size.height * 0.2,
        margin: EdgeInsets.all(widget.size.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: widget.size.width * 0.23,
              color: Colors.grey.shade400,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: widget.size.width * 0.02),
              child: AutoSizeText(
                maxLines: 1,
                'Add Item',
                style: TextStyle(
                  fontSize: widget.size.width * 0.07,
                  color: Colors.grey.shade300,
                ),
              ),
            )
          ],
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
            height: widget.size.height * 0.425,
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
                // * Enter Name Field
                formField(
                  initialValue: name,
                  label: 'Enter Name',
                  iconData: Icons.text_fields_outlined,
                  size: widget.size,
                  handleSave: (value) {
                    name = value!;
                  },
                  handleChange: (value) {
                    name = value;
                  },
                  handleValidate: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Item Name';
                    } else {
                      return null;
                    }
                  },
                  textInputType: TextInputType.text,
                ),
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
                Consumer(
                  builder: (context, ref, child) {
                    return FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.grey.shade900,
                      ),
                      onPressed: isProcessing
                          ? null
                          : () async {
                              setState(() {
                                isProcessing = true;
                              });
                              if (image!.path.isEmpty) {
                                toast(
                                    context: context,
                                    label: 'Please Choose Image',
                                    color: Colors.red);
                                return;
                              }
                              FormData formData;

                              formData = FormData.fromMap({
                                'name': name,
                                'photo': await MultipartFile.fromFile(
                                    image!.absolute.path),
                              });

                              ref
                                  .read(assetControllerProvider.notifier)
                                  .addAsset(formData)
                                  .then((value) {
                                if (value[0] == 'false') {
                                  name = '';
                                  toast(
                                      context: context,
                                      label: value[1],
                                      color: Colors.red);
                                } else {
                                  name = '';
                                  toast(
                                      context: context,
                                      label: value[1],
                                      color: Colors.green);
                                  image = null;
                                  ref.invalidate(assetControllerProvider);
                                  Navigator.of(context).pop();
                                }
                              });
                              setState(() {
                                isProcessing = false;
                              });
                            },
                      icon: const Icon(Icons.save_alt_outlined),
                      label: Text(
                        isProcessing ? 'Saving Item...' : 'Save Item',
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
