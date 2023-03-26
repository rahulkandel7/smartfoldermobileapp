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
            child: Image.network(
              photopath,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
