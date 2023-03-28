import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    String photopath = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  Image.asset('assets/logo/logo.png'),
              imageUrl: photopath,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
